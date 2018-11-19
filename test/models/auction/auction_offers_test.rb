require 'test_helper'

class AuctionOffersTest < ActiveSupport::TestCase
  # Test method related to getting offers out of auction
  def setup
    super

    @expired_auction = auctions(:expired)
    @persisted_auction = auctions(:valid_with_offers)
    @other_persisted_auction = auctions(:valid_without_offers)
    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_winning_offer_returns_an_offer_or_nil
    expected_winning_offer = offers(:expired_offer)
    assert_equal(expected_winning_offer, @expired_auction.winning_offer)
    assert_nil(@other_persisted_auction.winning_offer)
  end

  def test_highest_price_returns_money_object_or_nil
    auction = Auction.new(domain_name: 'some-domain.test')
    auction.starts_at = Time.now + 2.days
    auction.ends_at = Time.now + 3.days

    refute(auction.highest_price)
    assert_equal(Money.new(500, 'EUR'), @persisted_auction.highest_price)
  end

  def test_offer_from_user_returns_highest_offer_from_user_or_nil
    offer = offers(:minimum_offer)
    user = users(:participant)

    assert_equal(@persisted_auction.offer_from_user(user), offer)
    refute(@persisted_auction.offer_from_user(User.new))
  end

  def test_current_price_from_user_returns_a_money_object_or_nil
    user = users(:participant)
    assert_equal(Money.new(500, 'EUR'), @persisted_auction.current_price_from_user(user))
    refute(@persisted_auction.current_price_from_user(User.new))
  end

  def test_offers_count_returns_integer
    assert_equal(1, @persisted_auction.offers_count)
    assert_equal(1, @expired_auction.offers_count)
  end

  def test_without_result_scope_does_not_return_active_auctions
    assert_equal([].to_set, Auction.without_result.to_set)
    assert_equal([@persisted_auction, @other_persisted_auction].to_set, Auction.active.to_set)
  end

  def test_without_result_scope_returns_auctions_that_do_not_have_results
    travel_back
    assert_equal([@persisted_auction].to_set,
                 Auction.without_result.to_set)
    assert_equal([@persisted_auction, @other_persisted_auction, @expired_auction].to_set,
                 Auction.all.to_set)
  end
end
