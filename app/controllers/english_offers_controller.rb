class EnglishOffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: %i[show edit update destroy]
  before_action :authorize_phone_confirmation
  before_action :authorize_offer_for_user, except: %i[new index create]
  before_action :set_captcha_required

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers/new
  def new
    auction = Auction.find_by!(uuid: params[:auction_uuid])

    offer = auction.offer_from_user(current_user.id)
    redirect_to edit_english_offer_path(offer.uuid), notice: t('offers.already_exists') if offer

    BillingProfile.create_default_for_user(current_user.id)
    @offer = Offer.new(auction_id: auction.id, user_id: current_user.id)
  end

  # POST /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers
  def create
    auction = Auction.find_by!(uuid: params[:auction_uuid])

    unless auction.offers.empty?
      flash[:alert] = 'Bid already exists'
      redirect_to auctions_path and return
    end

    unless check_first_bid_for_english_auction(create_params, auction)
      flash[:alert] = "First bid should be more or equal that starter price #{auction.starting_price}"
      # redirect_to auctions_path and return
      redirect_to new_auction_english_offer_path(auction_uuid: auction.uuid) and return
    end

    @offer = Offer.new(create_params)
    authorize! :manage, @offer

    if create_predicate
      flash[:notice] = 'Bid created'
      redirect_to edit_english_offer_path(@offer.uuid)
    else
      flash[:alert] = 'Somethings goes wrong.'
      redirect_to auctions_path
    end
  end

  # GET /offers
  def index
    @offers = Offer.includes(:auction)
                   .includes(:result)
                   .where(user_id: current_user)
                   .order('auctions.ends_at DESC')
                   .page(params[:page])
  end

  # GET /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show; end

  # GET /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit; end

  # PUT /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    auction = Auction.with_user_offers(current_user.id).find_by(uuid: @offer.auction.uuid)

    unless check_bids_for_english_auction(create_params, auction)
      flash[:alert] = "Minimum bid is #{auction.min_bids_step}"

      redirect_to edit_english_offer_path(auction.users_offer_uuid) and return
    end

    if update_predicate
      update_minimum_bid_step(update_params[:price].to_f, auction)
      flash[:notice] = 'Bid updated'
      redirect_to edit_english_offer_path(@offer.uuid)
    else
      flash[:alert] = 'Somethings goes wrong.'
      redirect_to auctions_path
    end
  end

  # DELETE /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def destroy
    return unless @offer.can_be_modified? && @offer.destroy

    respond_to do |format|
      format.html { redirect_to auction_path(@offer.auction.uuid), notice: t(:deleted) }
      format.json { head :no_content }
    end
  end

  private

  def set_captcha_required
    @captcha_required = current_user.requires_captcha?
  end

  def create_predicate
    captcha_predicate = true
    # captcha_predicate = !@captcha_required || verify_recaptcha(model: @offer)
    captcha_predicate && @offer.save && @offer.reload
  end

  def create_params
    params.require(:offer).permit(:auction_id, :user_id, :price, :billing_profile_id)
  end

  def check_first_bid_for_english_auction(params, auction)
    return true if auction.blind?

    starting_price = auction.starting_price
    price = params[:price].to_f

    price.to_f >= starting_price.to_f
  end

  def check_bids_for_english_auction(params, auction)
    return true if auction.blind?

    minimum = auction.min_bids_step
    price = params[:price].to_f
    bids = price - @offer.price.to_f

    bids.to_f >= minimum.to_f
  end

  def update_predicate
    captcha_predicate = true
    # captcha_predicate = !@captcha_required || verify_recaptcha(model: @offer)
    captcha_predicate && @offer.update(update_params) && @offer.reload
  end

  def update_minimum_bid_step(bid, auction)
    update_value = 0.01

    if bid < 1.0
      update_value
    elsif bid > 1.0 && bid < 10.0
      update_value = update_value * 10
    elsif bid > 10.0 && bid < 100.0
      update_value = update_value * 100
    elsif bid > 100.0 && bid < 1000.0
      update_value = update_value * 1000
    elsif bid > 1000.0 && bid < 10000.0
      update_value = update_value * 10000
    elsif bid > 10000.0 && bid < 100000.0
      update_value = update_value * 100000
    end

    auction.min_bids_step = auction.min_bids_step + update_value
    auction.save
  end

  def update_params
    update_params = params.require(:offer).permit(:price, :billing_profile_id)
    merge_updated_by(update_params)
  end

  def set_offer
    @offer = Offer.where(user_id: current_user.id)
                  .find_by!(uuid: params[:uuid])
  end

  def authorize_phone_confirmation
    return unless current_user.requires_phone_number_confirmation?

    redirect_to new_user_phone_confirmation_path(current_user.uuid),
                notice: t('phone_confirmations.confirmation_required')
  end

  def authorize_offer_for_user
    authorize! :manage, @offer
  end
end
