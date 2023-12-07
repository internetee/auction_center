module Queries::Auction
  class WithMaxOfferCentsForEnglishAuction
    class << self
      def call(user: nil)
        new(user:).call
      end
    end

    def initialize(user: nil)
      @user = user
    end

    def call
      if @user
        Auction.joins(<<-SQL
          LEFT JOIN (
            SELECT auction_id, MAX(cents) AS max_offer_cents
            FROM offers
            WHERE auction_id IN (
              SELECT id FROM auctions WHERE platform = 1
              UNION
              SELECT auction_id FROM offers WHERE user_id = #{@user.id} AND auction_id IN (SELECT id FROM auctions WHERE platform IS NULL OR platform = 0)
            )
            GROUP BY auction_id
          ) AS offers_subquery ON auctions.id = offers_subquery.auction_id
        SQL
             )
      else
        Auction.joins(<<-SQL
          LEFT JOIN (
            SELECT auction_id, MAX(cents) AS max_offer_cents
            FROM offers
            WHERE auction_id IN (SELECT id FROM auctions WHERE platform = 1)
            GROUP BY auction_id
          ) AS offers_subquery ON auctions.id = offers_subquery.auction_id
        SQL
             )
      end
    end
  end
end
