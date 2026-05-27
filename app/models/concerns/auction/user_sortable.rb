module Auction::UserSortable
  extend ActiveSupport::Concern

  class_methods do
    def sorted_for_user(user) = user ? with_user_priority_sorting(user) : self

    private

    def with_user_priority_sorting(user)
      wishlist_domains = user.wishlist_items.pluck(:domain_name)
      interest_profile = user.recommendation_profile
      interest_categories = interest_profile&.rankable_interest_categories || []
      custom_interests = interest_profile&.custom_interests || []
      query = with_recommendation_scores(user.id)
      
      order_sql = if wishlist_domains.any?
                    build_five_tier_priority_sql(wishlist_domains, interest_categories, custom_interests)
                  else
                    build_four_tier_priority_sql(interest_categories, custom_interests)
                  end
      
      query.order(Arel.sql(order_sql))
    end

    def with_recommendation_scores(user_id)
      join_sql = ActiveRecord::Base.sanitize_sql_array([
        <<~SQL.squish,
          LEFT JOIN user_auction_scores
            ON user_auction_scores.auction_id = auctions.id
           AND user_auction_scores.user_id = ?
        SQL
        user_id
      ])

      joins(join_sql)
    end

    def build_five_tier_priority_sql(wishlist_domains, interest_categories, custom_interests)
      sanitized_domains = wishlist_domains.map { |d| ActiveRecord::Base.connection.quote(d) }.join(',')
      interest_match_sql = interest_match_sql(interest_categories, custom_interests)
      <<~SQL.squish
        CASE 
          WHEN auctions.users_offer_id IS NOT NULL THEN 0
          WHEN auctions.domain_name IN (#{sanitized_domains}) THEN 1
          WHEN user_auction_scores.score IS NOT NULL THEN 2
          WHEN #{interest_match_sql} THEN 3
          ELSE 4 
        END,
        CASE
          WHEN user_auction_scores.score IS NOT NULL THEN user_auction_scores.score
          WHEN auctions.ai_score > 0 THEN auctions.ai_score
          ELSE RANDOM()
        END DESC
      SQL
    end

    def build_four_tier_priority_sql(interest_categories, custom_interests)
      interest_match_sql = interest_match_sql(interest_categories, custom_interests)
      <<~SQL.squish
        CASE 
          WHEN auctions.users_offer_id IS NOT NULL THEN 0
          WHEN user_auction_scores.score IS NOT NULL THEN 1
          WHEN #{interest_match_sql} THEN 2
          ELSE 3 
        END,
        CASE
          WHEN user_auction_scores.score IS NOT NULL THEN user_auction_scores.score
          WHEN auctions.ai_score > 0 THEN auctions.ai_score
          ELSE RANDOM()
        END DESC
      SQL
    end

    def interest_match_sql(interest_categories, custom_interests)
      match_clauses = []

      if interest_categories.present?
        quoted_categories = interest_categories.map { |item| ActiveRecord::Base.connection.quote(item) }.join(',')
        match_clauses << "auctions.classification_tags && ARRAY[#{quoted_categories}]::varchar[]"
      end

      custom_interest_clauses = custom_interests.filter_map do |interest|
        normalized_interest = interest.to_s.strip.downcase
        next if normalized_interest.blank?

        pattern = "%#{ActiveRecord::Base.sanitize_sql_like(normalized_interest)}%"
        "LOWER(auctions.domain_name) LIKE #{ActiveRecord::Base.connection.quote(pattern)}"
      end

      match_clauses.concat(custom_interest_clauses)

      return 'FALSE' if match_clauses.empty?

      "(#{match_clauses.join(' OR ')})"
    end
  end
end