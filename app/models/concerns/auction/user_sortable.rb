module Auction::UserSortable
  extend ActiveSupport::Concern

  class_methods do
    def sorted_for_user(user) = user ? with_user_priority_sorting(user) : self

    private

    def with_user_priority_sorting(user)
      wishlist_domains = user.wishlist_items.pluck(:domain_name)
      
      order_sql = if wishlist_domains.any?
                    build_three_tier_priority_sql(wishlist_domains)
                  else
                    build_two_tier_priority_sql
                  end
      
      order(Arel.sql(order_sql))
    end

    def build_three_tier_priority_sql(wishlist_domains)
      sanitized_domains = wishlist_domains.map { |d| ActiveRecord::Base.connection.quote(d) }.join(',')
      <<~SQL.squish
        CASE 
          WHEN auctions.users_offer_id IS NOT NULL THEN 0
          WHEN auctions.domain_name IN (#{sanitized_domains}) THEN 1
          ELSE 2 
        END,
        CASE WHEN auctions.ai_score > 0 THEN auctions.ai_score ELSE RANDOM() END DESC
      SQL
    end

    def build_two_tier_priority_sql
      <<~SQL.squish
        CASE 
          WHEN auctions.users_offer_id IS NOT NULL THEN 0
          ELSE 1 
        END,
        CASE WHEN auctions.ai_score > 0 THEN auctions.ai_score ELSE RANDOM() END DESC
      SQL
    end
  end
end