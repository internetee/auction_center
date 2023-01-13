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
    assert(auction.can_be_deleted?)
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

  def test_english_auction_in_next_turn_should_be_also_as_english
    @with_invoice_auction.update(platform: :english)
    @with_invoice_auction.reload

    @with_invoice_auction._run_create_callbacks

    asserted_count_after_domain_registration = 1
    invoiceable_result = results(:expired_participant)
    invoiceable_result.update(auction: @with_invoice_auction,
                              status: Result.statuses[:domain_not_registered])

    assert_equal(asserted_count_after_domain_registration,
                 @with_invoice_auction.turns_count)
    assert @with_invoice_auction.english?
  end

  def test_english_auction_in_next_turn_should_be_same_starting_price_and_slipping_bid
    @with_invoice_auction.update(platform: :english, slipping_end: 7, starting_price: 10.0)
    @with_invoice_auction.reload

    @with_invoice_auction._run_create_callbacks

    asserted_count_after_domain_registration = 1
    invoiceable_result = results(:expired_participant)
    invoiceable_result.update(auction: @with_invoice_auction,
                              status: Result.statuses[:domain_not_registered])

    assert_equal(asserted_count_after_domain_registration,
                 @with_invoice_auction.turns_count)
    assert @with_invoice_auction.english?
    assert_equal @with_invoice_auction.slipping_end, 7
    assert_equal @with_invoice_auction.starting_price, 10.0
  end

  def test_english_auction_should_change_min_bid_after_actual_bid
    auction = auctions(:english)
    assert_equal auction.min_bids_step, 5.0

    auction.update_minimum_bid_step(5.1)
    auction.reload
    assert_equal auction.min_bids_step, 5.2

    auction.update_minimum_bid_step(11.0)
    auction.reload
    assert_equal auction.min_bids_step, 12.0
  end

  def test_min_bid_update_value_does_not_work_for_no_english_auctions
    auction = auctions(:valid_with_offers)
    assert_equal auction.min_bids_step, nil

    auction.update_minimum_bid_step(11.0)
    auction.reload
    assert_equal auction.min_bids_step, nil
  end

  def test_min_bid_update_should_return_error_if_bid_less_than_min_bid_required
    auction = auctions(:english)
    assert_equal auction.min_bids_step, 5.0

    auction.update_minimum_bid_step(4.8)
    auction.reload
    assert_not_equal auction.min_bids_step, 4.9
  end

  # def test_slipping_time_should_be_added_when_bid_added_in_specific_time
  #   slipping_end  = 7

  #   auction = auctions(:english)
  #   user = users(:participant)
  #   billing_profile = billing_profiles(:private_person)

  #   auction.update(ends_at: Time.zone.now + 6.minute, slipping_end: slipping_end)
  #   auction.reload

  #   offer = Offer.new
  #   offer.auction = auction
  #   offer.user = user
  #   offer.cents = 600
  #   offer.billing_profile = billing_profile
  #   offer.save

  #   auction.update_ends_at(offer)
  #   auction.reload

  #   minutes = (auction.ends_at - Time.zone.now) / 60
  #   assert_equal minutes.to_i, slipping_end
  # end

  # def test_slipping_time_should_not_be_added_when_bid_added_in_not_slipping_time
  #   slipping_end  = 5
  #   added_minutes = 6

  #   auction = auctions(:english)
  #   user = users(:participant)
  #   billing_profile = billing_profiles(:private_person)

  #   auction.update(ends_at: Time.zone.now + added_minutes.minutes, slipping_end: slipping_end)
  #   auction.reload

  #   offer = Offer.new
  #   offer.auction = auction
  #   offer.user = user
  #   offer.cents = 600
  #   offer.billing_profile = billing_profile
  #   offer.save

  #   auction.update_ends_at(offer)
  #   auction.reload

  #   minutes = (auction.ends_at - Time.zone.now) / 60
  #   assert_equal minutes.to_i, added_minutes
  # end

  def assert_overlap_error_messages(object)
    assert(object.errors[:ends_at].include?('overlaps with another auction'))
    assert(object.errors[:starts_at].include?('overlaps with another auction'))
  end

  def test_should_set_enable_deposit_for_english_auction
    refute @english.enable_deposit?
    @english.update(enable_deposit: true, requirement_deposit_in_cents: 5000)
    @english.reload

    assert @english.enable_deposit?
  end

  def test_should_not_set_enable_deposit_for_non_english_auction
    refute @other_persisted_auction.enable_deposit?
    @other_persisted_auction.update(enable_deposit: true)
    @other_persisted_auction.reload

    refute @other_persisted_auction.enable_deposit?
  end

  def test_no_change_if_deposit_enabled_without_the_deposit_price
    refute @english.enable_deposit?
    @english.update(enable_deposit: true, requirement_deposit_in_cents: 0)
    @english.reload

    refute @english.enable_deposit?
  end

  def test_no_change_if_deposit_price_but_deposit_is_disable
    refute @english.enable_deposit?
    @english.update(enable_deposit: false, requirement_deposit_in_cents: 5000)
    @english.reload

    refute @english.enable_deposit?
  end
end
