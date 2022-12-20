class Admin::FinishedAuctionsController < ApplicationController
  before_action :authorize_user

  def index
    # sort_column = params[:sort].presence_in(%w[domain name]) || 'id'
    # sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'

    auctions = Auction.where('ends_at <= ?', Time.zone.now).search(params)

    @pagy, @auctions = pagy(auctions, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
  end

  def authorize_user
    authorize! :manage, Auction
  end
end
