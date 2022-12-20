class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    auctions = Auction.where('ends_at <= ?', Time.zone.now).search(params)

    @pagy, @auctions = pagy(auctions, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
  end
end
