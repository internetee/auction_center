# frozen_string_literal: true

module Auction::SqlQueriable # rubocop:disable Metrics/ModuleLength
  extend ActiveSupport::Concern

  class_methods do
    def with_user_offers(user_id)
      Auction.from(with_user_offers_query(user_id))
    end

    def with_user_offers_query(user_id)
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

      ActiveRecord::Base.sanitize_sql([sql, user_id])
    end

    def with_highest_offers
      Auction.from(with_highest_offers_query)
    end

    def with_highest_offers_query
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

    def active_with_offers_count
      Auction.active.from(with_offers_count_query)
    end

    def with_offers_count_query
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

    def with_max_offer_cents_for_english_auction(user = nil)
      if user
        joins(<<-SQL
          LEFT JOIN (
            SELECT auction_id, MAX(cents) AS max_offer_cents
            FROM offers
            WHERE auction_id IN (
              SELECT id FROM auctions WHERE platform = 1
              UNION
              SELECT auction_id FROM offers WHERE user_id = #{user.id} AND auction_id IN (SELECT id FROM auctions WHERE platform IS NULL OR platform = 0)
            )
            GROUP BY auction_id
          ) AS offers_subquery ON auctions.id = offers_subquery.auction_id
        SQL
             )
      else
        joins(<<-SQL
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

    def sorted_by_winning_offer_username
      joins(<<-SQL
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
