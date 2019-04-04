class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: %i[show edit update destroy]
  before_action :authorize_phone_confirmation
  before_action :authorize_offer_for_user, except: %i[new index create]
  before_action :set_captcha_required

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers/new
  def new
    auction = Auction.find_by!(uuid: params[:auction_uuid])

    offer = auction.offer_from_user(current_user.id)
    redirect_to edit_offer_path(offer.uuid), notice: t('offers.already_exists') if offer

    BillingProfile.create_default_for_user(current_user.id)
    @offer = Offer.new(auction_id: auction.id, user_id: current_user.id)
  end

  # POST /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers
  def create
    auction = Auction.find_by!(uuid: params[:auction_uuid])
    existing_offer = auction.offer_from_user(current_user.id)

    @offer = Offer.new(create_params)
    authorize! :manage, @offer

    respond_to do |format|
      if existing_offer
        format.html do
          redirect_to offer_path(existing_offer.uuid), notice: t('offers.already_exists')
        end
      elsif create_predicate
        format.html { redirect_to offer_path(@offer.uuid), notice: t('.created') }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
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
    respond_to do |format|
      if update_predicate
        format.html { redirect_to offer_path(@offer.uuid), notice: t(:updated) }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
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
    captcha_predicate = !@captcha_required || verify_recaptcha(model: @offer)
    captcha_predicate && @offer.save && @offer.reload
  end

  def create_params
    params.require(:offer).permit(:auction_id, :user_id, :price, :billing_profile_id)
  end

  def update_predicate
    captcha_predicate = !@captcha_required || verify_recaptcha(model: @offer)
    captcha_predicate && @offer.update(update_params)
  end

  def update_params
    params.require(:offer).permit(:price, :billing_profile_id)
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
