# Query decorator for Auctions. Implements Orderable interface
class ParticipantAuctionDecorator
  attr_reader :auction

  def self.column_names
    # ApplicationRecord.column_names is a mutable object.
    column_names = Auction.column_names.dup

    column_names.append('users_offer_cents')
  end

  def self.table_name
    Auction.table_name
  end

  # Any object of this class works properly only with the new query with additional fields.
  # Passing a traditional auction object will produce errors on #users_price as well as
  # other delegate methods.
  def initialize(auction_with_additional_fields)
    @auction = auction_with_additional_fields
  end

  def self.with_user_offers(user_id)
    Auction.from(with_user_offers_query(user_id))
  end

  def users_price
    Money.new(auction.users_offer_cents, ApplicationSetting.auction_currency)
  end

  delegate :users_offer_id, to: :auction
  delegate :users_offer_uuid, to: :auction
  delegate :id, to: :auction
  delegate :uuid, to: :auction
  delegate :domain_name, to: :auction
  delegate :remote_id, to: :auction
  delegate :ends_at, to: :auction
  delegate :starts_at, to: :auction
  delegate :in_progress?, to: :auction

  # A simple subquery suffices here.
  def self.with_user_offers_query(user_id)
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
end
