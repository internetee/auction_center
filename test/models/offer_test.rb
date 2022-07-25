require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:valid_with_offers)
    @billing_profile = billing_profiles(:company)
    @user = users(:participant)
    @offer = offers(:expired_offer)

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_required_fields
    offer = Offer.new

    assert_not(offer.valid?)
    assert_equal(['must exist', 'This auction has ended'], offer.errors[:auction])
    assert_equal(['is not a number'], offer.errors[:cents])
    assert_equal(['must exist'], offer.errors[:billing_profile])

    offer.auction = @valid_auction
    offer.billing_profile = @billing_profile
    offer.cents = 1201

    assert(offer.valid?)
  end

  def test_auction_needs_to_be_active_to_create_an_offer
    offer = Offer.new

    offer.auction = @expired_auction
    offer.user = @user

    assert_not(offer.valid?(:create))
    assert_equal(['This auction has ended'], offer.errors[:auction])
  end

  def test_cents_must_be_an_integer
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 12.00

    assert_not(offer.valid?)

    assert_equal(['must be an integer'], offer.errors[:cents])
  end

  def test_cents_must_be_positive
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = -100

    assert_not(offer.valid?)
    assert_equal(['must be greater than 0'], offer.errors[:cents])
  end

  def test_total
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 1
    offer.billing_profile = @billing_profile

    offer.cents = 500

    assert_equal(offer.total, Money.new('500', 'EUR'))

    offer.billing_profile = billing_profiles(:private_person)
    assert_equal(offer.total, Money.new('600', 'EUR'))
  end

  def test_total_work_as_expected_if_billing_profile_was_deleted
    # vat - taxi
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 1
    offer.billing_profile = @billing_profile

    offer.cents = 500

    assert_equal(offer.total, Money.new('500', 'EUR'))

    offer.billing_profile = billing_profiles(:private_person)
    assert_equal(offer.total, Money.new('600', 'EUR'))

    offer.billing_profile = nil
    assert_equal(offer.total, Money.new('600', 'EUR'))
  end	

  def test_offer_must_be_higher_than_minimum_value_allowed_in_settings
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 1
    offer.billing_profile = @billing_profile

    assert_not(offer.valid?)
    assert_equal(['must be higher than 5.00'], offer.errors[:price])

    offer.cents = 500
    assert(offer.valid?)
  end

  def test_can_be_orphaned_by_a_user
    @user.destroy
    @offer.reload

    assert_nil(@offer.user)
    assert_nil(@offer.user_id)
  end

  def test_first_bid_must_be_higher_or_equal_to_starting_price
    auction = auctions(:english)
    auction.offers.destroy_all
    assert_equal auction.starting_price, 5.0

    offer = Offer.new
    offer.auction = auction
    offer.user = @user
    offer.cents = 6
    offer.billing_profile = @billing_profile
    offer.save

    auction.reload

    assert_equal(['First bid should be more or equal than starting price'], offer.errors[:price])
  end

  def test_if_first_bid_less_than_starting_price_from_wishlist_it_should_be_skipped
    auction = auctions(:english)
    auction.offers.destroy_all
    assert_equal auction.starting_price, 5.0

    wishlist_item = WishlistItem.new(domain_name: auction.domain_name, user: @user, cents: 300)
    wishlist_item.save(validate: false)

    FirstBidFromWishlistService.apply_bid(auction: auction)
    auction.reload

    assert_equal auction.offers.count, 0
  end

  def test_create_first_bid_from_wishlist_if_it_price_higher_that_starting_price
    auction = auctions(:english)
    auction.offers.destroy_all
    assert_equal auction.starting_price, 5.0

    wishlist_item = WishlistItem.new(domain_name: auction.domain_name, user: @user, cents: 600)
    wishlist_item.save(validate: false)

    FirstBidFromWishlistService.apply_bid(auction: auction)
    auction.reload

    assert_equal auction.offers.count, 1
  end

  def test_next_bid_should_be_higher_than_previous_for_english_auction_by_min_bid_step
    auction = auctions(:english)
    offer = Offer.new
    offer.auction = auction
    offer.user = @user
    offer.cents = 500
    offer.billing_profile = @billing_profile
    offer.save
    auction.reload

    assert_equal auction.currently_winning_offer.cents, 500

    offer = Offer.new
    offer.auction = auction
    offer.user = @user
    offer.cents = 400
    offer.billing_profile = @billing_profile
    offer.save
    auction.reload

    assert_equal(['First bid should be more or equal than starting price',
                  'Next bid should be higher or equal than minimum bid step'], offer.errors[:price])
  end

  def test_if_next_bid_higher_or_equal_that_min_bid_then_no_any_errors
    auction = auctions(:english)
    offer = Offer.new
    offer.auction = auction
    offer.user = @user
    offer.cents = 500
    offer.billing_profile = @billing_profile
    offer.save
    auction.reload

    assert_equal auction.currently_winning_offer.cents, 500

    offer = Offer.new
    offer.auction = auction
    offer.user = @user
    offer.cents = 510
    offer.billing_profile = @billing_profile
    offer.save
    auction.reload

    assert_equal([], offer.errors[:price])

    offer = Offer.new
    offer.auction = auction
    offer.user = @user
    offer.cents = 700
    offer.billing_profile = @billing_profile
    offer.save
    auction.reload

    assert_equal([], offer.errors[:price])
  end
end
