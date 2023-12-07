module Queries::Auction
  class WithUserOffersQuery
    class << self
      def call(user_id:)
        new(user_id:).call
      end
    end

    def initialize(user_id:)
      @user_id = user_id
    end

    def call
      sql = <<~SQL
        (WITH offers_subquery AS (
            SELECT *
            FROM offers
            WHERE user_id = ?
        )
        SELECT DISTINCT
            auctions.*,
            offers_subquery.cents AS users_offer_cents,
            offers_subquery.id AS users_offer_id,
            offers_subquery.uuid AS users_offer_uuid
        FROM auctions
        LEFT JOIN offers_subquery on auctions.id = offers_subquery.auction_id) AS auctions
      SQL

      ActiveRecord::Base.sanitize_sql([sql, @user_id])
    end
  end
end
