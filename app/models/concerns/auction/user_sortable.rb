module Auction::UserSortable
  extend ActiveSupport::Concern

  # v3: ordering collapses to three buckets. Personalisation now lives entirely
  # in user_auction_scores.score (magnet pull + structural nudges — see
  # Recommendation::Scorer), so the old string-matched "interest" tier and its
  # domain_classifications join are gone. An auction with no score row falls to
  # the tail, ranked by global ai_score then RANDOM.
  #
  #   bucket 0: the user's own offer
  #   bucket 1: a wishlisted domain           (only when a wishlist exists)
  #   bucket 2: has a personal score
  #   bucket 3: everything else (ai_score / RANDOM tail)
  class_methods do
    def sorted_for_user(user) = user ? with_user_priority_sorting(user) : self

    private

    def with_user_priority_sorting(user)
      wishlist_domains = user.wishlist_items.pluck(:domain_name)
      query = with_recommendation_scores(user.id)

      order_sql = if wishlist_domains.any?
                    build_wishlist_priority_sql(wishlist_domains)
                  else
                    build_priority_sql
                  end

      query.order(Arel.sql(order_sql))
    end

    def with_recommendation_scores(user_id)
      scores_join = ActiveRecord::Base.sanitize_sql_array([
        <<~SQL.squish,
          LEFT JOIN user_auction_scores
            ON user_auction_scores.auction_id = auctions.id
           AND user_auction_scores.user_id = ?
        SQL
        user_id
      ])

      joins(scores_join)
    end

    def build_wishlist_priority_sql(wishlist_domains)
      sanitized_domains = wishlist_domains.map { |d| ActiveRecord::Base.connection.quote(d) }.join(',')
      <<~SQL.squish
        CASE
          WHEN auctions.users_offer_id IS NOT NULL THEN 0
          WHEN auctions.domain_name IN (#{sanitized_domains}) THEN 1
          WHEN user_auction_scores.score IS NOT NULL THEN 2
          ELSE 3
        END,
        #{secondary_key_sql}
      SQL
    end

    def build_priority_sql
      <<~SQL.squish
        CASE
          WHEN auctions.users_offer_id IS NOT NULL THEN 0
          WHEN user_auction_scores.score IS NOT NULL THEN 1
          ELSE 2
        END,
        #{secondary_key_sql}
      SQL
    end

    def secondary_key_sql
      <<~SQL.squish
        CASE
          WHEN user_auction_scores.score IS NOT NULL THEN user_auction_scores.score
          WHEN auctions.ai_score > 0 THEN auctions.ai_score
          ELSE RANDOM()
        END DESC
      SQL
    end
  end
end
