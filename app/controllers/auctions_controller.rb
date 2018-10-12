class AuctionsController < ApplicationController
  before_action :authorize_user

  def index
    @auctions = Auction.active.accessible_by(current_ability)
  end

  def show
    @auction = Auction.accessible_by(current_ability).find(params[:id])
  end

  def authorize_user
    authorize! :read, Auction
  end
end
