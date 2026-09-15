class AuctionsController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:cors_preflight_check]
  before_action :authorize_user

  DEFAULT_PAGE_LIMIT = 15

  # Hard ceiling for one rendered page. A single auction row costs ~270KB of transient
  # objects to render, so an unbounded page size (show_all, or a hand-crafted per_page)
  # lets one request blow the container memory limit and take the process down.
  MAX_PAGE_LIMIT = 100

  # GET /auctions
  def index
    set_cors_header

    @auctions_list = fetch_auctions_list
    @pagy, @auctions = pagy(
      @auctions_list,
      limit: per_page_count,
      link_extra: 'data-turbo-action="advance"'
    )

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    redirect_to root_path, status: :moved_permanently
  end

  # OPTIONS /auctions
  def cors_preflight_check
    set_access_control_headers

    render plain: ''
  end

  private

  def fetch_auctions_list = Auction.active.search(params, current_user)

  def per_page_count
    return MAX_PAGE_LIMIT if params[:show_all] == 'true'

    requested = params[:per_page].to_i
    return DEFAULT_PAGE_LIMIT unless requested.positive?

    [requested, MAX_PAGE_LIMIT].min
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
