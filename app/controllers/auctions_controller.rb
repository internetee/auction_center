class AuctionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:cors_preflight_check]
  before_action :authorize_user

  # GET /auctions
  def index
    set_cors_header
    auctions = Auction.active.search(params).with_user_offers(current_user&.id)

    @pagy, @auctions = pagy(auctions, items: params[:per_page] ||= 15, link_extra: 'data-turbo-action="advance"')
  end

  # OPTIONS /auctions
  def cors_preflight_check
    set_access_control_headers

    render plain: ''
  end

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @auction = Auction.with_user_offers(current_user).accessible_by(current_ability).find_by!(uuid: params[:uuid])
  end

  private

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
