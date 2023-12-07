module Queries::Auction
  class SortedByWinningOfferUsername
    class << self
      def call
        new.call
      end
    end

    def call
      Auction.joins(<<-SQL
      LEFT JOIN (
        SELECT offers.auction_id, offers.username
        FROM offers
        WHERE offers.cents = (
          SELECT MAX(offers_inner.cents)
          FROM offers AS offers_inner
          WHERE offers_inner.auction_id = offers.auction_id
        )
        GROUP BY offers.auction_id, offers.username
      ) AS offers_subquery ON auctions.id = offers_subquery.auction_id
      SQL
           )
    end
  end
end
