class AuctionsController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:cors_preflight_check]
  before_action :authorize_user

  DEFAULT_PAGE_LIMIT = 15

  # GET /auctions
  def index
    set_cors_header

    @auctions_list = fetch_auctions_list
    @pagy, @auctions = pagy(
      @auctions_list,
      limit: per_page_count,
      link_extra: 'data-turbo-action="advance"'
    )
    @show_recommendation_prompt = current_user&.recommendation_profile_promptable?
    @domain_classifications = preload_domain_classifications(@auctions)

    track_recommendation_impressions

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
    count = params[:show_all] == 'true' ? @auctions_list.count : per_page
    count = nil if count.zero?
    count
  end

  def per_page = params[:per_page] || DEFAULT_PAGE_LIMIT

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

  def track_recommendation_impressions
    return unless current_user
    return unless request.format.html?

    Recommendation::EventTracker.track_impressions(
      user: current_user,
      auctions: @auctions,
      source: 'auctions#index',
      request:
    )
  end

  def preload_domain_classifications(auctions)
    return {} if auctions.blank?

    domain_names = auctions.map { |a| a.domain_name.to_s.downcase }.uniq
    DomainClassification.where(domain_name: domain_names).index_by(&:domain_name)
  rescue ActiveRecord::StatementInvalid
    # Table not yet migrated; safely degrade.
    {}
  end
end
