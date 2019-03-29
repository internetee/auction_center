class AuctionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:cors_preflight_check]
  before_action :authorize_user

  # GET /auctions
  def index
    set_cors_header

    unpaginated_auctions = Auction.active.includes(:offers).accessible_by(current_ability)

    respond_to do |format|
      format.html { @auctions = unpaginated_auctions.page(params[:page]) }
      format.json { @auctions = unpaginated_auctions }
    end
  end

  # GET /auctions/search
  def search
    domain_name = search_params[:domain_name]

    @auctions = Auction.where('domain_name ILIKE ?', "#{domain_name}%")
                       .includes(:offers)
                       .accessible_by(current_ability)
                       .page(1)
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
    params.permit(:domain_name)
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
