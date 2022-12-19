
class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    sort_column = params[:sort].presence_in(%w[domain name]) || 'id'
    sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'

    auctions = Auction.where('ends_at <= ?', Time.zone.now).search(params).order(sort_column => sort_direction)

    @pagy, @auctions = pagy(auctions, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
  end
end
