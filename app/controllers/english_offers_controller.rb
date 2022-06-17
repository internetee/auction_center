class EnglishOffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: %i[show edit update]
  before_action :authorize_phone_confirmation
  before_action :authorize_offer_for_user, except: %i[new create]
  before_action :set_captcha_required
  
  protect_from_forgery with: :null_session

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers/new
  def new
    auction = Auction.find_by!(uuid: params[:auction_uuid])

    offer = auction.offer_from_user(current_user.id)
    redirect_to edit_english_offer_path(offer.uuid), notice: t('offers.already_exists') if offer

    @autobider = Autobider.find_by(domain_name: auction.domain_name, user: current_user)
    @autobider = current_user.autobiders.build(domain_name: auction.domain_name) if @autobider.nil?

    BillingProfile.create_default_for_user(current_user.id)
    @offer = Offer.new(auction_id: auction.id, user_id: current_user.id)
  end

  # POST /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers
  def create
    auction = Auction.find_by!(uuid: params[:auction_uuid])

    unless check_first_bid_for_english_auction(create_params, auction)
      flash[:alert] = "First bid should be more or equal that starter price #{auction.starting_price}"
      redirect_to new_auction_english_offer_path(auction_uuid: auction.uuid) and return
    end

    @offer = Offer.new(create_params)
    authorize! :manage, @offer

    captcha_predicate = true
    # captcha_predicate = !@captcha_required || verify_recaptcha(model: @offer)
    unless captcha_predicate
      flash[:alert] = 'Captcha verification failed'
      redirect_to request.referrer and return
    end

    if create_predicate(auction)
      update_auction_values(auction, 'Offer submitted successfully.')
      auction.broadcast_replace_to "auctions_offer_#{auction.id}",
                                    target: "offer_#{auction.id}_form",
                                    partial: 'english_offers/number_form_field',
                                    locals: {offer_value: auction.min_bids_step , offer_disabled: auction.finished? ? true : false }
    else
      flash[:alert] = 'Somethings goes wrong.'
      redirect_to request.referrer
    end
  end

  # GET /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show; end

  # GET /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit
    auction = @offer.auction

    @autobider = Autobider.find_by(domain_name: auction.domain_name, user: current_user)
    @autobider = current_user.autobiders.build(domain_name: auction.domain_name) if @autobider.nil?
  end

  # PUT /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    auction = Auction.with_user_offers(current_user.id).find_by(uuid: @offer.auction.uuid)

    if bid_is_bad?(auction: auction, update_params: update_params)
      flash[:alert] = "Bid failed, current price is #{auction.highest_price.to_f}"
      redirect_to edit_english_offer_path(auction.users_offer_uuid) and return
    end

    captcha_predicate = true
    # captcha_predicate = !@captcha_required || verify_recaptcha(model: @offer)

    unless captcha_predicate
      flash[:alert] = 'Captcha verification failed'
      redirect_to request.referrer and return
    end

    if update_predicate(auction)
      update_auction_values(auction, 'Bid updated')
      auction.broadcast_replace_to "auctions_offer_#{auction.id}",
                                  target: "offer_#{auction.id}_form",
                                  partial: 'english_offers/number_form_field',
                                  locals: {offer_value: auction.min_bids_step , offer_disabled: auction.finished? ? true : false }
    else
      flash[:alert] = 'Somethings goes wrong.'
      redirect_to request.referrer
    end
  end

  private

  def update_auction_values(auction, message_text)
    AutobiderService.autobid(auction)
    auction.update_ends_at(@offer)

    flash[:notice] = message_text
    redirect_to edit_english_offer_path(@offer.uuid)
  end

  def bid_is_bad?(auction:, update_params:)
    !additional_check_for_bids(auction, update_params[:price]) ||
      !check_bids_for_english_auction(update_params, auction)
  end

  def additional_check_for_bids(auction, current_bid)
    order = auction.offers.order(updated_at: :desc).first

    Money.new(order.cents).to_f < current_bid.to_f
  end

  def set_captcha_required
    @captcha_required = current_user.requires_captcha?
  end

  def create_predicate(auction)
    @offer.save && auction.update_minimum_bid_step(create_params[:price].to_f) && @offer.reload
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

    minimum = auction.min_bids_step.to_f
    price = params[:price].to_f

    price >= minimum
  end

  def update_predicate(auction)
    @offer.update(update_params) &&
    auction.update_minimum_bid_step(create_params[:price].to_f) &&
    @offer.reload
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
