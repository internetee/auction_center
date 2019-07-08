require 'test_helper'

class ExtendedAuctionTest < ActiveSupport::TestCase
  def setup
    super

    @persisted_auction = auctions(:valid_with_offers)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_with_highest_offers_scope_returns_a_relation_of_auctions
    auctions = ExtendedAuction.with_highest_offers

    extended_auction = auctions.find_by(auctions: { domain_name: 'with-offers.test' })
    assert_equal(@persisted_auction.id, extended_auction.id)
    assert_equal(@persisted_auction.uuid, extended_auction.uuid)
    assert_equal(@persisted_auction.domain_name, extended_auction.domain_name)
    assert_equal(@persisted_auction.starts_at, extended_auction.starts_at)
    assert_equal(@persisted_auction.ends_at, extended_auction.ends_at)
  end

  def test_instance_implements_highest_price_method
    auctions = ExtendedAuction.with_highest_offers
    extended_auction = ExtendedAuction.new(
      auctions.find_by(auctions: { domain_name: 'with-offers.test' })
    )
    assert_equal(Money.new(5000, Setting.auction_currency), extended_auction.highest_price)
  end
end
