require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @persisted_auction = auctions(:valid_with_offers)
    @other_persisted_auction = auctions(:valid_without_offers)
    @orphaned_auction = auctions(:orphaned)
    @with_invoice_auction = auctions(:with_invoice)
    @english = auctions(:english)
    @english_nil = auctions(:english_nil_starts)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_required_fields
    auction = Auction.new

    assert_not(auction.valid?)
    assert_equal(["can't be blank"], auction.errors[:domain_name])
    # In english auction version these columns can be nil 
    # assert_equal(["can't be blank"], auction.errors[:ends_at])
    # assert_equal(["can't be blank"], auction.errors[:starts_at])

    auction.domain_name = 'domain-to-auction.test'
    auction.ends_at = Time.now.in_time_zone + 2.days
    auction.starts_at = Time.now.in_time_zone
    assert(auction.valid?)
  end

  def test_finished_returns_a_boolean
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.starts_at = Time.now.in_time_zone
    auction.ends_at = Time.now.in_time_zone + 1.day

    assert_not(auction.finished?)
    assert(@expired_auction.finished?)
  end

  def test_starts_at_cannot_be_in_the_past_on_create
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.ends_at = Time.now.in_time_zone + 2.days
    auction.starts_at = Time.now.in_time_zone - 2.days

    assert_not(auction.valid?(:create))
    assert(auction.valid?(:update))
  end

  def test_in_progress_returns_a_boolean
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.starts_at = Time.now.in_time_zone + 2.days
    auction.ends_at = Time.now.in_time_zone + 3.days

    assert_not(auction.in_progress?)
  end

  def test_can_be_deleted_returns_a_boolean
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.starts_at = Time.now.in_time_zone - 2.days
    auction.ends_at = Time.now.in_time_zone + 3.days

    assert_not(auction.can_be_deleted?)

    auction.starts_at = Time.now.in_time_zone + 2.days
    auction.ends_at = Time.now.in_time_zone + 3.days

    assert(auction.can_be_deleted?)
  end

  def test_time_related_method_return_false_for_invalid_auctions
    auction = Auction.new

    assert_not(auction.in_progress?)
    assert_not(auction.can_be_deleted?)
    assert_not(auction.finished?)
  end

  def test_auction_must_end_later_than_it_starts
    auction = Auction.new(domain_name: 'some-domain-name.test',
                          ends_at: Time.parse('2010-07-04 19:30 +0000').in_time_zone,
                          starts_at: Time.parse('2010-07-05 11:30 +0000').in_time_zone)

    assert_not(auction.valid?)
    assert_equal(auction.errors[:starts_at], ['must be earlier than ends_at'])
  end

  def test_auction_must_be_unique_for_its_duration
    finishes_earlier_starts_earlier = Auction.new(domain_name: @persisted_auction.domain_name,
                                                  ends_at: Time.parse('2010-07-05 19:30 +0000').in_time_zone,
                                                  starts_at: Time.parse('2010-07-05 00:30 +0000').in_time_zone)

    assert_not(finishes_earlier_starts_earlier.valid?)
    assert_overlap_error_messages(finishes_earlier_starts_earlier)

    finishes_later_starts_earlier = Auction.new(domain_name: @persisted_auction.domain_name,
                                                ends_at: Time.parse('2010-07-06 19:30 +0000').in_time_zone,
                                                starts_at: Time.parse('2010-07-05 00:30 +0000').in_time_zone)

    assert_not(finishes_later_starts_earlier.valid?)
    assert_overlap_error_messages(finishes_later_starts_earlier)

    finishes_earlier_starts_later = Auction.new(domain_name: @persisted_auction.domain_name,
                                                ends_at: Time.parse('2010-07-06 19:30 +0000').in_time_zone,
                                                starts_at: Time.parse('2010-07-05 00:30 +0000').in_time_zone)
    assert_not(finishes_earlier_starts_later.valid?)
    assert_overlap_error_messages(finishes_earlier_starts_later)
  end

  def test_turns_count_set_if_no_domain_registered
    asserted_count_results_total = 2
    invoiceable_result = results(:expired_participant)
    invoiceable_result.update(auction: @with_invoice_auction,
                              status: Result.statuses[:domain_not_registered])
    noninvoiceable_result = results(:without_offers_nobody)
    @other_persisted_auction.update!(domain_name: @with_invoice_auction.domain_name,
                                     starts_at: @with_invoice_auction.starts_at + 1.month,
                                     ends_at: @with_invoice_auction.ends_at + 1.month)
    noninvoiceable_result.update(auction: @other_persisted_auction,
                                 status: Result.statuses[:domain_not_registered])
    assert_equal(asserted_count_results_total, @other_persisted_auction.calculate_turns_count)
  end

  def test_turns_count_drops_if_domain_registered
    asserted_count_after_domain_registration = 1
    invoiceable_result = results(:expired_participant)
    invoiceable_result.update(auction: @with_invoice_auction,
                              status: Result.statuses[:domain_not_registered])
    noninvoiceable_result = results(:without_offers_nobody)
    @other_persisted_auction.update!(domain_name: @with_invoice_auction.domain_name,
                                     starts_at: @with_invoice_auction.starts_at + 1.month,
                                     ends_at: @with_invoice_auction.ends_at + 1.month)
    noninvoiceable_result.update(auction: @other_persisted_auction,
                                 status: Result.statuses[:domain_registered])
    assert_equal(asserted_count_after_domain_registration,
                 @with_invoice_auction.calculate_turns_count)

  end

  def test_auction_creation_uses_callbacks
    @with_invoice_auction._run_create_callbacks

    asserted_count_after_domain_registration = 1
    invoiceable_result = results(:expired_participant)
    invoiceable_result.update(auction: @with_invoice_auction,
                              status: Result.statuses[:domain_not_registered])

    assert_equal(asserted_count_after_domain_registration,
                 @with_invoice_auction.turns_count)
  end

  def assert_overlap_error_messages(object)
    assert(object.errors[:ends_at].include?('overlaps with another auction'))
    assert(object.errors[:starts_at].include?('overlaps with another auction'))
  end
end
