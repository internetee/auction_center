class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    # sort_column = params[:sort].presence_in(%w[domain_name starts_at ends_at]) || 'id'
    # sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'
    # .order(sort_column => sort_direction)

    auctions = Auction.where('ends_at <= ?', Time.zone.now).search(params)

    @pagy, @auctions = pagy(auctions, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
  end
end
