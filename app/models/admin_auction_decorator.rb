# Query decorator for Auctions. Implements Orderable interface
class AdminAuctionDecorator
  attr_reader :auction
  attr_accessor :auction_currency

  def self.column_names
    # ApplicationRecord.column_names is a mutable object.
    column_names = Auction.column_names.dup

    column_names.append('highest_offer_cents', 'number_of_offers')
  end

  def self.table_name
    Auction.table_name
  end

  # Any object of this class works properly only with the new query with additional fields.
  # Passing a traditional auction object will produce errors on #highest_price as well as
  # other delegate methods.
  def initialize(auction_with_additional_fields, auction_currency)
    @auction = auction_with_additional_fields
    @auction_currency = auction_currency
  end

  def self.with_highest_offers
    Auction.from(with_highest_offers_query)
  end

  def highest_price
    Money.new(auction.highest_offer_cents, @auction_currency)
  end

  delegate :number_of_offers, to: :auction
  delegate :highest_offer_id, to: :auction
  delegate :highest_offer_uuid, to: :auction
  delegate :id, to: :auction
  delegate :uuid, to: :auction
  delegate :domain_name, to: :auction
  delegate :remote_id, to: :auction
  delegate :ends_at, to: :auction
  delegate :starts_at, to: :auction
  delegate :turns_count, to: :auction

  # Use window functions to find the winning offer, and then append those fields to
  # the auction dataset. It is considerably slower than original query, but does not contain any
  # additional queries once the first one is done.
  #
  # Returns the dataset as auction objects, and then leverages the way in which ActiveRecord
  # infers methods from database schema. As a result, you can use the following:
  #
  # auction = ExtendedAuction.with_highest_offers.first
  # auction.highest_offer_uuid => "f4c8bb6b-00f2-4bb0-a097-4a5265fd1c9c"
  # auction.highest_offer_id => 156
  def self.with_highest_offers_query
    sql = <<~SQL
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

    sql
  end
end
