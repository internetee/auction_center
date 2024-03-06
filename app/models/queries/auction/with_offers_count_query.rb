module Queries::Auction
  class WithOffersCountQuery
    class << self
      def call
        new.call
      end
    end

    def call
      <<~SQL
        (SELECT
            auctions.*,
            offers.cents,
            recent_offers.offers_count
        FROM auctions
        LEFT JOIN (
            SELECT auction_id,
                   MAX(updated_at) as last_updated_at,
                   COUNT(*) as offers_count
            FROM offers
            GROUP BY auction_id
        ) AS recent_offers ON auctions.id = recent_offers.auction_id
        LEFT JOIN offers ON auctions.id = offers.auction_id AND offers.updated_at = recent_offers.last_updated_at) AS auctions
      SQL
    end
  end
end
