class EnglishOffersController < ApplicationController  
  before_action :authenticate_user!
  before_action :find_auction, only: %i[new create]
  before_action :check_for_ban, only: :create
  before_action :set_offer, only: %i[show edit update]
  before_action :set_captcha_required
  before_action :authorize_phone_confirmation
  before_action :authorize_offer_for_user, except: %i[new create]
  before_action :prevent_check_for_invalid_bid, only: [:update]
  before_action :captcha_check, only: %i[update create]

  protect_from_forgery with: :null_session

  include OfferNotifable

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers/new
  def new
    offer = @auction.offer_from_user(current_user.id)
    redirect_to edit_english_offer_path(offer.uuid) if offer

    @autobider = Autobider.find_by(domain_name: @auction.domain_name, user: current_user)
    @autobider = current_user.autobiders.build(domain_name: @auction.domain_name) if @autobider.nil?

    BillingProfile.create_default_for_user(current_user.id)
    @offer = Offer.new(auction_id: @auction.id, user_id: current_user.id)
  end

  # POST /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers
  def create
    unless check_first_bid_for_english_auction(create_params, @auction)
      formatted_starting_price = format('%.2f', @auction.starting_price)
      flash[:alert] = t('english_offers.create.bid_must_be', minimum: formatted_starting_price)
      redirect_to new_auction_english_offer_path(auction_uuid: @auction.uuid) and return
    end

    @offer = Offer.new(create_params)
    @offer.username = Username::GenerateUsernameService.new.call
    authorize! :manage, @offer

    if create_predicate(@auction)
      broadcast_update_auction_offer(@auction)
      send_outbided_notification(auction: @auction, offer: @offer, flash: flash)
      update_auction_values(@auction, t('english_offers.create.created'))
    else
      if @offer.errors.full_messages_for(:cents).present?
        flash[:alert] = @offer.errors.full_messages_for(:cents).join
      else
        flash[:alert] = @offer.errors.full_messages.join('; ')
      end

      redirect_to root_path
    end
  end

  # GET /english_offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @auction = @offer.auction
    render template: 'offers/show'
  end

  # GET /english_offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit
    @auction = @offer.auction
    redirect_to auction_path(@auction.uuid) and return if update_not_allowed(@auction)

    @autobider = current_user.autobiders.find_by(domain_name: @auction.domain_name)
    @autobider = current_user.autobiders.build(domain_name: @auction.domain_name) if @autobider.nil?
  end

  # PUT /english_offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    auction = Auction.english.with_user_offers(current_user.id).find_by(uuid: @offer.auction.uuid)
    redirect_to auction_path(auction.uuid) and return if update_not_allowed(auction)

    if update_predicate(auction)
      broadcast_update_auction_offer(auction)
      send_outbided_notification(auction: auction, offer: @offer, flash: flash)
      update_auction_values(auction, t('english_offers.edit.bid_updated'))
    else
      if @offer.errors.full_messages_for(:cents).present?
        flash[:alert] = @offer.errors.full_messages_for(:cents).join
      else
        flash[:alert] = @offer.errors.full_messages.join('; ')
      end

      redirect_to root_path
    end
  end

  private

  def find_auction
    @auction = Auction.english.find_by!(uuid: params[:auction_uuid])
  end

  def update_not_allowed(auction)
    !auction.english? || !auction.in_progress?
  end

  def check_for_ban
    if Ban.valid.where(user_id: current_user).where(domain_name: @auction.domain_name).any? || current_user.completely_banned?
      redirect_to root_path, flash: { alert: I18n.t('.english_offers.create.ban') } and return
    end
  end

  def broadcast_update_auction_offer(auction)
    Offers::UpdateBroadcastService.call({ auction: auction })
  end

  def captcha_check
    return if Rails.env.development?

    captcha_predicate = !@captcha_required || verify_recaptcha(model: @offer)
    return if captcha_predicate

    flash[:alert] = t('english_offers.form.captcha_verification')
    redirect_to request.referer and return
  end

  def update_auction_values(auction, message_text)
    AutobiderService.autobid(auction)
    auction.update_ends_at(@offer)

    flash[:notice] = message_text
    redirect_to edit_english_offer_path(@offer.uuid)
  end

  def prevent_check_for_invalid_bid
    auction = Auction.with_user_offers(current_user.id).find_by(uuid: @offer.auction.uuid)
    return unless bid_is_bad?(auction: auction, update_params: update_params)

    flash[:alert] = "#{t('english_offers.show.bid_failed', price: sprintf('%.2f', auction.highest_price.to_f).gsub('.', ','))}"
    redirect_to edit_english_offer_path(auction.users_offer_uuid) and return
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
    params.require(:offer).permit(:auction_id, :user_id, :price, :billing_profile_id, :username)
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
    @offer = current_user.offers.find_by!(uuid: params[:uuid])
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
