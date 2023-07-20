# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_auction, only: %i[new create]
  before_action :set_offer, only: %i[show edit update destroy]
  before_action :check_for_ban, only: :create
  before_action :authorize_phone_confirmation
  before_action :authorize_offer_for_user, except: %i[new index create]

  include RecaptchaValidatable
  recaptcha_action 'offer'

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers/new
  def new
    offer = @auction.offer_from_user(current_user.id)
    redirect_to edit_offer_path(offer.uuid), notice: t('offers.already_exists') if offer

    BillingProfile.create_default_for_user(current_user.id)
    @offer = Offer.new(auction_id: @auction.id, user_id: current_user.id)
  end

  # POST /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers
  def create
    existing_offer = @auction.offer_from_user(current_user.id)

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
        @show_checkbox_recaptcha = true unless @success
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /offers
  def index
    offers = Offer.includes(:auction)
                  .includes(:result)
                  .where(user_id: current_user)
                  .order('auctions.ends_at DESC')

    @pagy, @offers = pagy(offers, items: params[:per_page] ||= 15)
  end

  # GET /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @auction = @offer.auction
  end

  # GET /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit
    auction = @offer.auction
    redirect_to auction_path(auction.uuid) and return if update_not_allowed(auction)
  end

  # PUT /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    auction = @offer.auction
    redirect_to auction_path(auction.uuid) and return if update_not_allowed(auction)

    respond_to do |format|
      if update_predicate
        format.html { redirect_to offer_path(@offer.uuid), notice: t(:updated) }
        format.json { render :show, status: :ok, location: @offer }
      else
        @show_checkbox_recaptcha = true unless @success
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def destroy
    return if @offer.auction.english?
    return unless @offer.can_be_modified? && @offer.destroy

    respond_to do |format|
      format.html { redirect_to auction_path(@offer.auction.uuid), notice: t(:deleted) }
      format.json { head :no_content }
    end
  end

  private

  def find_auction
    @auction = Auction.find_by!(uuid: params[:auction_uuid], platform: 'blind')
  end

  def update_not_allowed(auction)
    auction.english? || !auction.in_progress?
  end

  def check_for_ban
    if Ban.valid.where(user_id: current_user).where(domain_name: @auction.domain_name).any? || current_user.completely_banned?
      redirect_to root_path, flash: { alert: I18n.t('.offers.create.ban') } and return
    end
  end

  def create_predicate
    recaptcha_valid && @offer.save && @offer.reload
  end

  def create_params
    params.require(:offer).permit(:auction_id, :user_id, :price, :billing_profile_id)
  end

  def update_predicate
    recaptcha_valid && @offer.update(update_params)
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
