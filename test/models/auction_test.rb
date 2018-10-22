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
    assert_equal(["can't be blank"], auction.errors[:starts_at])

    auction.domain_name = 'domain-to-auction.test'
    auction.ends_at = Time.now + 2.days
    auction.starts_at = Time.now
    assert(auction.valid?)
  end

  def test_finished_returns_a_boolean
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.starts_at = Time.now
    auction.ends_at = Time.now + 1.day

    refute(auction.finished?)
    assert(@expired_auction.finished?)
  end

  def test_starts_at_cannot_be_in_the_past_on_create
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.ends_at = Time.now + 2.days
    auction.starts_at = Time.now - 2.days

    refute(auction.valid?(:create))
    assert(auction.valid?(:update))
  end

  def test_in_progress_returns_a_boolean
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.starts_at = Time.now + 2.days
    auction.ends_at = Time.now + 3.days

    refute(auction.in_progress?)
  end

  def test_can_be_deleted_returns_a_boolean
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.starts_at = Time.now - 2.days
    auction.ends_at = Time.now + 3.days

    refute(auction.can_be_deleted?)

    auction.starts_at = Time.now + 2.days
    auction.ends_at = Time.now + 3.days

    assert(auction.can_be_deleted?)
  end

  def test_active_scope_returns_only_active_auction
    assert_equal([@persisted_auction], Auction.active)
    assert_equal([@persisted_auction, @expired_auction].to_set, Auction.all.to_set)

    travel_to Time.parse('2010-07-04 10:30 +0000')
    assert_equal([], Auction.active)
    travel_back
  end

  def test_time_related_method_return_false_for_invalid_auctions
    auction = Auction.new

    refute(auction.in_progress?)
    refute(auction.can_be_deleted?)
    refute(auction.finished?)
  end

  def test_auction_must_end_later_than_it_starts
    auction = Auction.new(domain_name: 'some-domain-name.test',
                          ends_at: Time.parse('2010-07-04 19:30 +0000'),
                          starts_at: Time.parse('2010-07-05 11:30 +0000'))

    refute(auction.valid?)
    assert_equal(auction.errors[:starts_at], ['must be earlier than ends_at'])
  end

  def test_auction_must_be_unique_for_its_duration
    finishes_earlier_starts_earlier = Auction.new(domain_name: @persisted_auction.domain_name,
                                                  ends_at: Time.parse('2010-07-05 19:30 +0000'),
                                                  starts_at: Time.parse('2010-07-05 00:30 +0000'))

    refute(finishes_earlier_starts_earlier.valid?)
    assert_overlap_error_messages(finishes_earlier_starts_earlier)

    finishes_later_starts_earlier = Auction.new(domain_name: @persisted_auction.domain_name,
                                                ends_at: Time.parse('2010-07-06 19:30 +0000'),
                                                starts_at: Time.parse('2010-07-05 00:30 +0000'))

    refute(finishes_later_starts_earlier.valid?)
    assert_overlap_error_messages(finishes_later_starts_earlier)

    finishes_earlier_starts_later =   Auction.new(domain_name: @persisted_auction.domain_name,
                                                  ends_at: Time.parse('2010-07-06 19:30 +0000'),
                                                  starts_at: Time.parse('2010-07-05 00:30 +0000'))
    refute(finishes_earlier_starts_later.valid?)
    assert_overlap_error_messages(finishes_earlier_starts_later)
  end

  def assert_overlap_error_messages(object)
    assert(object.errors[:ends_at].include?('overlaps with another auction'))
    assert(object.errors[:starts_at].include?('overlaps with another auction'))
  end
end
