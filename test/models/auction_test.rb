require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @persisted_auction = auctions(:id_test)
    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_required_fields
    auction = Auction.new

    refute(auction.valid?)
    assert_equal(["can't be blank"], auction.errors[:domain_name])
    assert_equal(["can't be blank"], auction.errors[:ends_at])

    auction.domain_name = 'domain-to-auction.test'
    auction.ends_at = Time.now + 2.days
    assert(auction.valid?)
  end

  def test_finished_returns_a_boolean
    auction = Auction.new
    auction.ends_at = Time.now + 2.days

    refute(auction.finished?)

    auction.ends_at = Time.now - 2.days

    assert(auction.finished?)
  end

  def test_active_scope_returns_only_active_auction
    assert_equal([@persisted_auction], Auction.active)
    assert_equal([@persisted_auction, @expired_auction].to_set, Auction.all.to_set)
  end

  def test_auction_must_be_unique_for_its_duration
    finishes_earlier_starts_earlier = Auction.new(domain_name: @persisted_auction.domain_name,
                                                  ends_at: Time.parse('2010-07-05 19:30 +0000'),
                                                  starts_at: Time.parse('2010-07-05 00:30 +0000'))

    refute(finishes_earlier_starts_earlier.valid?)

    finishes_later_starts_earlier = Auction.new(domain_name: @persisted_auction.domain_name,
                                                ends_at: Time.parse('2010-07-06 19:30 +0000'),
                                                starts_at: Time.parse('2010-07-05 00:30 +0000'))

    refute(finishes_later_starts_earlier.valid?)

    finishes_earlier_starts_later =   Auction.new(domain_name: @persisted_auction.domain_name,
                                                  ends_at: Time.parse('2010-07-06 19:30 +0000'),
                                                  starts_at: Time.parse('2010-07-05 00:30 +0000'))
    refute(finishes_earlier_starts_later.valid?)
  end
end
