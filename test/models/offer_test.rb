require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:id_test)
    @user = users(:participant)

    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_required_fields
    offer = Offer.new

    refute(offer.valid?)
    assert_equal(["must exist", "must be active"], offer.errors[:auction])
    assert_equal(["must exist"], offer.errors[:user])
    assert_equal(["is not a number"], offer.errors[:cents])

    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 1201

    assert(offer.valid?)
  end

  def test_auction_needs_to_be_active_to_create_an_offer
    offer = Offer.new

    offer.auction = @expired_auction
    offer.user = @user

    refute(offer.valid?(:create))
    assert_equal(["must be active"], offer.errors[:auction])
  end

  def test_cents_must_be_an_integer
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 12.000

    refute(offer.valid?)

    assert_equal(["must be an integer"], offer.errors[:cents])
  end

  def test_cents_must_be_positive
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = -100

    refute(offer.valid?)
    assert_equal(["must be greater than 0"], offer.errors[:cents])
  end
end
