class AuctionsController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:cors_preflight_check]
  before_action :authorize_user

  DEFAULT_PAGE_LIMIT = 15

  # GET /auctions
  def index
    set_cors_header
    @auctions_list = fetch_auctions_list
    @pagy, @auctions = pagy(@auctions_list, limit: per_page_count, link_extra: 'data-turbo-action="advance"')

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

  def fetch_auctions_list
    if should_sort_auctions? && current_user
      wishlist_domains = current_user.wishlist_items.pluck(:domain_name)
      
      Auction.active
             .search(params, current_user)
             .with_user_offers(current_user.id)
             .order(Arel.sql(build_priority_order_sql(wishlist_domains)))
    elsif should_sort_auctions?
      Auction.active.ai_score_order.search(params, current_user).with_user_offers(nil)
    else
      Auction.active.search(params, current_user).with_user_offers(current_user&.id)
    end
  end

  def build_priority_order_sql(wishlist_domains)
    if wishlist_domains.any?
      sanitized_domains = wishlist_domains.map { |d| ActiveRecord::Base.connection.quote(d) }.join(',')
      <<~SQL.squish
        CASE 
          WHEN users_offer_id IS NOT NULL THEN 0
          WHEN auctions.domain_name IN (#{sanitized_domains}) THEN 1
          ELSE 2 
        END,
        CASE WHEN ai_score > 0 THEN ai_score ELSE RANDOM() END DESC
      SQL
    else
      <<~SQL.squish
        CASE 
          WHEN users_offer_id IS NOT NULL THEN 0
          ELSE 1 
        END,
        CASE WHEN ai_score > 0 THEN ai_score ELSE RANDOM() END DESC
      SQL
    end
  end

  def should_sort_auctions?
    params[:sort_by].blank? && params[:sort_direction].blank?
  end

  def per_page
    params[:per_page] || DEFAULT_PAGE_LIMIT
  end

  def per_page_count
    count = params[:show_all] == 'true' ? @auctions_list.count : per_page
    count = nil if count.zero?
    count
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
