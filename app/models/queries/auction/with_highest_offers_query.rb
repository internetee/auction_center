module Queries::Auction
  class WithHighestOffersQuery
    class << self
      def call
        new.call
      end
    end

    def call
      <<~SQL
        (WITH offers_subquery AS (
            SELECT DISTINCT on (uuid) offers.*
            FROM (SELECT auction_id,
                max(cents) over (PARTITION BY auction_id)             as max_price,
                min(created_at) over (PARTITION BY auction_id, cents) as min_time
                FROM offers
        ) AS highest_offers
        INNER JOIN offers
        ON
            offers.cents = highest_offers.max_price AND
            offers.created_at = highest_offers.min_time AND
            offers.auction_id = highest_offers.auction_id)
        SELECT DISTINCT
            auctions.*,
            offers_subquery.cents AS highest_offer_cents,
            offers_subquery.id AS highest_offer_id,
            offers_subquery.uuid AS highest_offer_uuid,
            (SELECT COUNT(*) FROM offers where offers.auction_id = auctions.id) AS number_of_offers
        FROM auctions
        LEFT JOIN offers_subquery on auctions.id = offers_subquery.auction_id) AS auctions
      SQL
    end
  end
end
