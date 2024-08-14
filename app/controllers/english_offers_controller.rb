# frozen_string_literal: true

class EnglishOffersController < ApplicationController
  before_action :set_offer, only: %i[show edit update]

  include BeforeRender
  include Offerable
  protect_from_forgery with: :null_session

  # order is important
  include EnglishOffers::Offerable

  include RecaptchaValidatable
  recaptcha_action 'english_offer'
  include OfferNotifable

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers/new
  def new
    prevent_check_for_existed_offer and return if @auction.offer_from_user(current_user.id)

    BillingProfile.create_default_for_user(current_user.id)
    @offer = Offer.new(auction_id: @auction.id, user_id: current_user.id)
  end

  # POST /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers
  def create
    inform_about_invalid_bid_amount and return unless check_first_bid_for_english_auction(create_params, @auction)
    inform_invalid_captcha and return unless recaptcha_valid

    @offer = Offer.new(create_params)
    @offer.username = Username::GenerateUsernameService.new.call
    authorize! :manage, @offer

    if create_predicate(@auction)
      broadcast_update_auction_offer(@auction)
      send_outbided_notification(auction: @auction, offer: @offer, flash:)
      update_auction_values(@auction, t('english_offers.create.created'))
      Rails.logger.info("User #{current_user.id} created offer #{@offer.id} for auction #{@auction.id}")
    else
      errors = if @offer.errors.full_messages_for(:cents).present?
                 @offer.errors.full_messages_for(:cents).join
               else
                 @offer.errors.full_messages.join('; ')
               end
      flash[:alert] = errors
      Rails.logger.error("User #{current_user.id} tried to create offer for auction #{@auction.id} but it failed. Errors: #{errors}")
      redirect_to root_path and return
    end
  end

  # GET /english_offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @auction = @offer.auction
  end

  # GET /english_offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit
    @auction = @offer.auction
    redirect_to auction_path(@auction.uuid) and return if update_not_allowed(@auction)
  end

  # PUT /english_offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    @auction = Auction.english.with_user_offers(current_user.id).find_by(uuid: @offer.auction.uuid)
    redirect_to auction_path(@auction.uuid) and return if update_not_allowed(@auction)
    inform_invalid_captcha and return unless recaptcha_valid

    if update_predicate(@auction)
      broadcast_update_auction_offer(@auction)
      send_outbided_notification(auction: @auction, offer: @offer, flash:)
      update_auction_values(@auction, t('english_offers.edit.bid_updated'))
      Rails.logger.info("User #{current_user.id} updated offer #{@offer.id} for auction #{@auction.id}")
    else
      errors = if @offer.errors.full_messages_for(:cents).present?
                 @offer.errors.full_messages_for(:cents).join
               else
                 @offer.errors.full_messages.join('; ')
               end

      flash[:alert] = errors
      Rails.logger.error("User #{current_user.id} tried to update offer for auction #{offer.auction.id} but it failed. Errors: #{errors}")
      redirect_to root_path
    end
  end

  private

  def create_predicate(auction)
    @offer.save && auction.update_minimum_bid_step(create_params[:price].to_f) && @offer.reload
  end

  def create_params
    params.require(:offer).permit(:auction_id, :user_id, :price, :billing_profile_id, :username)
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
end
