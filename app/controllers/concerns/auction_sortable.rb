module AuctionSortable
  extend ActiveSupport::Concern

  def fetch_auctions_list
    if should_sort_auctions? && current_user
      sort_by_bids_and_wishlist_for_logged_in_user
    elsif should_sort_auctions?
      sort_by_ai_for_anonymous_user
    else
      fetch_active_auctions
    end
  end

  def sort_by_bids_and_wishlist_for_logged_in_user
    wishlist_domains = current_user.wishlist_items.pluck(:domain_name)
      
    Auction.active
           .search(params, current_user)
           .with_user_offers(current_user.id)
           .order(Arel.sql(build_priority_order_sql(wishlist_domains)))
  end

  def sort_by_ai_for_anonymous_user
    Auction.active.ai_score_order.search(params, current_user).with_user_offers(nil)
  end

  def fetch_active_auctions
    Auction.active.search(params, current_user).with_user_offers(current_user&.id)
  end

  def build_priority_order_sql(wishlist_domains)
    if wishlist_domains.any?
      build_three_tier_priority_sql(wishlist_domains)
    else
      build_two_tier_priority_sql
    end
  end

  def build_three_tier_priority_sql(wishlist_domains)
    sanitized_domains = wishlist_domains.map { |d| ActiveRecord::Base.connection.quote(d) }.join(',')
    <<~SQL.squish
      CASE 
        WHEN users_offer_id IS NOT NULL THEN 0
        WHEN auctions.domain_name IN (#{sanitized_domains}) THEN 1
        ELSE 2 
      END,
      CASE WHEN ai_score > 0 THEN ai_score ELSE RANDOM() END DESC
    SQL
  end

  def build_two_tier_priority_sql
    <<~SQL.squish
      CASE 
        WHEN users_offer_id IS NOT NULL THEN 0
        ELSE 1 
      END,
      CASE WHEN ai_score > 0 THEN ai_score ELSE RANDOM() END DESC
    SQL
  end

  def should_sort_auctions?
    params[:sort_by].blank? && params[:sort_direction].blank?
  end
end
