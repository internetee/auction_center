# frozen_string_literal: true

module Auction::Searchable
  extend ActiveSupport::Concern

  BLIND = 'blind'
  ENGLISH = 'english'

  FILTERING_COLUMNS = %w[domain_name
                         starts_at
                         ends_at
                         highest_offer_cents
                         number_of_offers
                         turns_count
                         starting_price
                         min_bids_step
                         slipping_end
                         platform
                         requirement_deposit_in_cents
                         enable_deposit].freeze

  included do
    scope :active, -> { where('starts_at <= ? AND ends_at >= ?', Time.now.utc, Time.now.utc) }
    scope :without_result, lambda {
      where('ends_at < ? and id NOT IN (SELECT results.auction_id FROM results)', Time.now.utc)
    }

    scope :for_period, lambda { |start_date, end_date|
      where(ends_at: start_date.beginning_of_day..end_date.end_of_day)
    }

    scope :random_order, -> { order(Arel.sql('RANDOM()')) }
    scope :ai_score_order, lambda {
      order(Arel.sql('CASE WHEN ai_score > 0 THEN ai_score ELSE RANDOM() END DESC'))
    }

    scope :without_offers, -> { includes(:offers).where(offers: { auction_id: nil }) }
    scope :with_offers, -> { includes(:offers).where.not(offers: { auction_id: nil }) }
    scope :with_domain_name, (lambda do |domain_name|
      return unless domain_name.present?

      where('domain_name like ?', "%#{domain_name}%")
    end)

    scope :with_type, (lambda do |type|
      if type.present? && type.in?([BLIND, ENGLISH])
        return where(platform: [type, nil]) if type == BLIND

        where(platform: type)
      end
    end)

    scope :with_starts_at, (lambda do |starts_at|
      where('starts_at >= ?', starts_at.to_date.beginning_of_day) if starts_at.present?
    end)

    scope :with_ends_at, (lambda do |ends_at|
      where('ends_at <= ?', ends_at.to_date.end_of_day) if ends_at.present?
    end)
    scope :with_starts_at_nil, ->(state) { where(starts_at: nil) if state.present? }

    scope :english, -> { where(platform: :english) }
    scope :not_english, -> { where.not(platform: :english) }

    scope :with_offers, (lambda do |auction_offer_type, type|
      return if auction_offer_type.blank? || type == BLIND || type.empty?

      case auction_offer_type
      when 'with_offers'
        auction_id_list = self.select { |a| a.offers.present? }.pluck(:id)
      when 'without_offers'
        auction_id_list = self.select { |a| a.offers.empty? }.pluck(:id)
      end

      where(id: auction_id_list)
    end)
  end

  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  class_methods do
    def search(params = {}, current_user = nil)
      param_list = %w[domain_name starts_at ends_at platform users_price]
      sort_column = params[:sort].presence_in(param_list) || 'domain_name'
      sort_admin_column = params[:sort].presence_in(FILTERING_COLUMNS) || 'id'
      sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'
      is_from_admin = params[:admin] == 'true'

      query =
        with_highest_offers
        .with_domain_name(params[:domain_name])
        .with_type(params[:type])
        .with_starts_at(params[:starts_at])
        .with_ends_at(params[:ends_at])
        .with_starts_at_nil(params[:starts_at_nil])
        .with_offers(params[:auction_offer_type], params[:type])

      if params[:sort] == 'users_price'
        query.with_max_offer_cents_for_english_auction(current_user)
             .order("offers_subquery.max_offer_cents #{sort_direction} NULLS LAST")
      elsif params[:sort] == 'username'
        query.sorted_by_winning_offer_username.order("offers_subquery.username #{sort_direction} NULLS LAST")
      else
        query.order("#{is_from_admin ? sort_admin_column : sort_column} #{sort_direction} NULLS LAST")
      end
    end

    def with_user_offers(user_id)
      Auction.from(with_user_offers_query(user_id))
    end

    def with_user_offers_query(user_id)
      Queries::Auction::WithUserOffersQuery.call(user_id:)

      # sql = <<~SQL
      #   (WITH offers_subquery AS (
      #       SELECT *
      #       FROM offers
      #       WHERE user_id = ?
      #   )
      #   SELECT DISTINCT
      #       auctions.*,
      #       offers_subquery.cents AS users_offer_cents,
      #       offers_subquery.id AS users_offer_id,
      #       offers_subquery.uuid AS users_offer_uuid
      #   FROM auctions
      #   LEFT JOIN offers_subquery on auctions.id = offers_subquery.auction_id) AS auctions
      # SQL

      # ActiveRecord::Base.sanitize_sql([sql, user_id])
    end

    def with_highest_offers
      Auction.from(with_highest_offers_query)
    end

    def with_highest_offers_query
      Queries::Auction::WithHighestOffersQuery.call

      # <<~SQL
      #   (WITH offers_subquery AS (
      #       SELECT DISTINCT on (uuid) offers.*
      #       FROM (SELECT auction_id,
      #           max(cents) over (PARTITION BY auction_id)             as max_price,
      #           min(created_at) over (PARTITION BY auction_id, cents) as min_time
      #           FROM offers
      #   ) AS highest_offers
      #   INNER JOIN offers
      #   ON
      #       offers.cents = highest_offers.max_price AND
      #       offers.created_at = highest_offers.min_time AND
      #       offers.auction_id = highest_offers.auction_id)
      #   SELECT DISTINCT
      #       auctions.*,
      #       offers_subquery.cents AS highest_offer_cents,
      #       offers_subquery.id AS highest_offer_id,
      #       offers_subquery.uuid AS highest_offer_uuid,
      #       (SELECT COUNT(*) FROM offers where offers.auction_id = auctions.id) AS number_of_offers
      #   FROM auctions
      #   LEFT JOIN offers_subquery on auctions.id = offers_subquery.auction_id) AS auctions
      # SQL
    end

    def active_with_offers_count
      Auction.active.from(with_offers_count_query)
    end

    def with_offers_count_query
      Queries::Auction::WithOffersCountQuery.call

      # <<~SQL
      #   (SELECT
      #       auctions.*,
      #       offers.cents,
      #       recent_offers.offers_count
      #   FROM auctions
      #   LEFT JOIN (
      #       SELECT auction_id,
      #              MAX(updated_at) as last_updated_at,
      #              COUNT(*) as offers_count
      #       FROM offers
      #       GROUP BY auction_id
      #   ) AS recent_offers ON auctions.id = recent_offers.auction_id
      #   LEFT JOIN offers ON auctions.id = offers.auction_id AND offers.updated_at = recent_offers.last_updated_at) AS auctions
      # SQL
    end

    def with_max_offer_cents_for_english_auction(user = nil)
      Queries::Auction::WithMaxOfferCentsForEnglishAuction.call(user: user)

      # if user
      #   joins(<<-SQL
      #     LEFT JOIN (
      #       SELECT auction_id, MAX(cents) AS max_offer_cents
      #       FROM offers
      #       WHERE auction_id IN (
      #         SELECT id FROM auctions WHERE platform = 1
      #         UNION
      #         SELECT auction_id FROM offers WHERE user_id = #{user.id} AND auction_id IN (SELECT id FROM auctions WHERE platform IS NULL OR platform = 0)
      #       )
      #       GROUP BY auction_id
      #     ) AS offers_subquery ON auctions.id = offers_subquery.auction_id
      #   SQL
      #        )
      # else
      #   joins(<<-SQL
      #     LEFT JOIN (
      #       SELECT auction_id, MAX(cents) AS max_offer_cents
      #       FROM offers
      #       WHERE auction_id IN (SELECT id FROM auctions WHERE platform = 1)
      #       GROUP BY auction_id
      #     ) AS offers_subquery ON auctions.id = offers_subquery.auction_id
      #   SQL
      #        )
      # end
    end

    def sorted_by_winning_offer_username
      Queries::Auction::SortedByWinningOfferUsername.call

      # joins(<<-SQL
      #   LEFT JOIN (
      #     SELECT offers.auction_id, offers.username
      #     FROM offers
      #     WHERE offers.cents = (
      #       SELECT MAX(offers_inner.cents)
      #       FROM offers AS offers_inner
      #       WHERE offers_inner.auction_id = offers.auction_id
      #     )
      #     GROUP BY offers.auction_id, offers.username
      #   ) AS offers_subquery ON auctions.id = offers_subquery.auction_id
      # SQL
      #      )
    end
  end
end
