class Admin::FinishedAuctionsController < ApplicationController
  before_action :authorize_user
  # before_action :set_auction, only: %i[show destroy]

  def index
    # @auctions = 
  end

  def authorize_user
    authorize! :manage, Auction
  end
end
