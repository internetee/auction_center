class Admin::FinishedAuctionsController < ApplicationController
  before_action :authorize_user
  include PagyHelper

  include Pagy::Backend
  # before_action :set_auction, only: %i[show destroy]

  def index
    sort_column = params[:sort].presence_in(%w{ domain name }) || "id"
    sort_direction = params[:direction].presence_in(%w{ asc desc }) || "desc"

    auctions = Auction.where('ends_at <= ?', Time.zone.now).search(params).order(sort_column => sort_direction)

    @pagy, @auctions = pagy(auctions, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
  end

  def authorize_user
    authorize! :manage, Auction
  end
end
