class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, except: :new

  def new
    @offer = Offer.new(
      auction_id: params[:auction_id], user_id: current_user.id
    )
  end

  def show
    @offer = Offer.accessible_by(current_ability).find(params[:id])
  end

  def authorize_user
    authorize! :manage, Offer
  end
end
