require 'test_helper'

class AuctionOffersTest < ActiveSupport::TestCase
  # Test method related to getting offers out of auction
  def setup
    super

    @expired_auction = auctions(:expired)
    @persisted_auction = auctions(:valid_with_offers)
    @other_persisted_auction = auctions(:valid_without_offers)
    @orphaned_auction = auctions(:orphaned)
    @with_invoice_auction = auctions(:with_invoice)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_winning_offer_returns_an_offer_or_nil
    expected_winning_offer = offers(:expired_offer)
    assert_equal(expected_winning_offer, @expired_auction.currently_winning_offer)
    assert_nil(@other_persisted_auction.currently_winning_offer)
  end

  def test_winning_offer_returns_currently_winning_offer_with_user_id
    expected_winning_offer = offers(:high_offer)
    assert_equal(expected_winning_offer, @persisted_auction.currently_winning_offer)

    participant = users(:participant)
    participant.destroy

    expected_winning_offer = offers(:minimum_offer)
    assert_equal(expected_winning_offer, @persisted_auction.currently_winning_offer)
    assert_nil(@other_persisted_auction.currently_winning_offer)
  end

  def test_winning_offer_returns_the_earliest_offer_in_case_of_a_draw
    expected_winning_offer = offers(:minimum_offer)
    other_offer = offers(:high_offer)
    some_time = Time.parse('2010-07-05 10:30 +0000').in_time_zone

    expected_winning_offer.update!(created_at: some_time)
    assert_equal(other_offer, @persisted_auction.currently_winning_offer)

    other_offer.update!(cents: expected_winning_offer.cents, created_at: some_time + 1)
    assert_equal(expected_winning_offer, @persisted_auction.currently_winning_offer)
  end

  def test_highest_price_returns_money_object_or_nil
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.starts_at = Time.now.in_time_zone + 2.days
    auction.ends_at = Time.now.in_time_zone + 3.days

    assert_not(auction.highest_price)
    assert_equal(Money.new(5000, 'EUR'), @persisted_auction.highest_price)
  end

  def test_offer_from_user_returns_highest_offer_from_user_or_nil
    offer = offers(:high_offer)
    user = users(:participant)

    assert_equal(@persisted_auction.offer_from_user(user), offer)
    assert_not(@persisted_auction.offer_from_user(User.new))
  end

  def test_current_price_from_user_returns_a_money_object_or_nil
    user = users(:participant)
    assert_equal(Money.new(5000, 'EUR'), @persisted_auction.current_price_from_user(user))
    assert_not(@persisted_auction.current_price_from_user(User.new))
  end

  def test_offers_count_returns_integer
    assert_equal(2, @persisted_auction.offers_count)
    assert_equal(1, @expired_auction.offers_count)
  end

  def test_without_result_scope_does_not_return_active_auctions
    assert_equal([].to_set, Auction.without_result.to_set)
    assert_equal([@persisted_auction, @other_persisted_auction,
                  @orphaned_auction, @with_invoice_auction].to_set,
                 Auction.active.to_set)
  end

  def test_without_result_scope_returns_auctions_that_do_not_have_results
    travel_back
    assert_equal([@persisted_auction].to_set,
                 Auction.without_result.to_set)
    assert_equal([@persisted_auction, @other_persisted_auction,
                  @expired_auction, @orphaned_auction, @with_invoice_auction].to_set,
                 Auction.all.to_set)
  end
end
