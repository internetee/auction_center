# frozen_string_literal: true

# rubocop:disable Metrics
class OffersController < ApplicationController
  include Offerable

  before_action :set_offer, only: %i[show edit update destroy]
  before_action :authorize_offer_for_user, except: %i[new index create delete]

  include RecaptchaValidatable
  recaptcha_action 'offer'

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/offers/new
  def new
    prevent_check_for_existed_offer and return if @auction.offer_from_user(current_user.id)

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
          redirect_to root_path, notice: t('offers.already_exists')
        end
      elsif create_predicate
        format.html { redirect_to root_path, notice: t('.created') }
        format.json { render :show, status: :created, location: @offer }
      else
        @show_checkbox_recaptcha = true unless @success
        flash[:alert] = recaptcha_valid ? @offer.errors.full_messages.join('; ') : t('offers.form.captcha_verification')

        format.html { redirect_to root_path, status: :see_other }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /offers
  def index
    offers = current_user.offers.search(params)
    @pagy, @offers = pagy(offers, items: params[:per_page] ||= 15)
  end

  # GET /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @auction = @offer.auction
  end

  # GET /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit
    auction = @offer.auction
    redirect_to root_path and return if update_not_allowed(auction)
  end

  # PUT /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    auction = @offer.auction
    redirect_to root_path and return if update_not_allowed(auction)

    respond_to do |format|
      if update_predicate
        format.html { redirect_to root_path, notice: t(:updated), status: :see_other }
        format.json { render :show, status: :ok, location: @offer }
      else
        @show_checkbox_recaptcha = true unless @success
        flash[:alert] = recaptcha_valid ? @offer.errors.full_messages.join('; ') : t('offers.form.captcha_verification')

        format.html { redirect_to root_path, status: :see_other }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def destroy
    return if @offer.auction.english?

    if @offer.can_be_modified? && @offer.destroy
      respond_to do |format|
        format.html { redirect_to auctions_path, notice: t(:deleted), status: :see_other }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to offer_path(@offer.uuid), notice: t(:not_deleted), status: :see_other }
        format.json { head :no_content }
      end
    end
  end

  def delete
    @offer = current_user.offers.find_by!(uuid: params[:offer_uuid])
    authorize! :manage, @offer
  end

  private

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
end
