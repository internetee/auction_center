class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: %i[show edit update destroy]
  before_action :authorize_user, except: :new

  # GET /auctions/1/offers/new
  def new
    auction = Auction.find_by!(uuid: params[:auction_uuid])

    @offer = Offer.new(
      auction_id: auction.id, user_id: current_user.id
    )
  end

  # POST /auctions/1/offers
  def create
    @offer = Offer.new(create_params)

    respond_to do |format|
      if @offer.save && @offer.reload
        format.html { redirect_to offer_path(@offer.uuid), notice: t(:created) }
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
                   .accessible_by(current_ability)
                   .where(user_id: current_user)
                   .order('auctions.ends_at DESC')
  end

  # GET /offers/1
  def show; end

  # GET /offers/1/edit
  def edit; end

  # PUT /offers/1
  def update
    respond_to do |format|
      if @offer.update(update_params)
        format.html { redirect_to offer_path(@offer.uuid), notice: t(:updated) }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  def destroy
    return unless @offer.can_be_modified? && @offer.destroy

    respond_to do |format|
      format.html { redirect_to auction_path(@offer.auction.uuid), notice: t(:deleted) }
      format.json { head :no_content }
    end
  end

  private

  def create_params
    params.require(:offer).permit(:auction_id, :user_id, :price, :billing_profile_id)
  end

  def update_params
    params.require(:offer).permit(:price, :billing_profile_id)
  end

  def set_offer
    @offer = Offer.accessible_by(current_ability)
                  .where(user_id: current_user.id)
                  .find_by!(uuid: params[:uuid])
  end

  def authorize_user
    authorize! :manage, Offer
  end
end
