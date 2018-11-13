require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @valid_auction = auctions(:valid_with_offers)
    @expired_auction = auctions(:expired)
  end

  def teardown
    super

    travel_back
  end

  def test_required_fields
    result = Result.new

    refute(result.valid?)

    assert_equal(["must exist"], result.errors[:auction])
    assert_equal(["can't be blank"], result.errors[:sold])
  end

  def test_create_result_from_an_auction_only_works_if_the_auction_has_finished
    assert_raises(Errors::AuctionNotFinished) do
      Result.create_from_auction(@valid_auction.id)
    end

    assert_raises(Errors::AuctionNotFound) do
      Result.create_from_auction("foo")
    end
  end

  def test_price_is_a_money_object
    result = Result.new(cents: 1000)

    assert_equal(Money.new(1000, Setting.auction_currency), result.price)

    result.cents = nil
    assert_equal(Money.new(0, Setting.auction_currency), result.price)
  end
end
