class Admin::FinishedAuctionsController < ApplicationController
  before_action :authorize_user

  def index
    auctions = Auction.where('ends_at <= ?', Time.zone.now).search(params)
    @pagy, @auctions = pagy(auctions, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
  end

  def authorize_user
    authorize! :manage, Auction
  end
end
