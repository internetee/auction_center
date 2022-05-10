class AuctionsController < ApplicationController
  include OrderableHelper

  skip_before_action :verify_authenticity_token, only: [:cors_preflight_check]
  before_action :authorize_user

  # GET /auctions
  def index
    set_cors_header
    @auctions = Auction.with_user_offers(current_user&.id).active
                # .active_filters
  end

  # GET /auctions/search
  def search
    domain_name = search_params[:domain_name]

    collection = ParticipantAuctionDecorator.with_user_offers(current_user&.id)
                                            .where('domain_name ILIKE ?', "#{domain_name}%")
                                            .order(orderable_array)
                                            .accessible_by(current_ability)
                                            .page(1)
                                            # .active_filters

    @auctions = collection.map { |auction| ParticipantAuctionDecorator.new(auction) }
  end

  # OPTIONS /auctions
  def cors_preflight_check
    set_access_control_headers

    render plain: ''
  end

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @auction = Auction.accessible_by(current_ability).find_by!(uuid: params[:uuid])
  end

  private

  def search_params
    search_params_copy = params.dup
    search_params_copy.permit(:domain_name)
  end

  def set_cors_header
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
  end

  def set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
    response.headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, ' \
                                                       'Authorization, Token, Auth-Token, '\
                                                       'Email, X-User-Token, X-User-Email'
    response.headers['Access-Control-Max-Age'] = '3600'
  end

  def authorize_user
    authorize! :read, Auction
  end
end
