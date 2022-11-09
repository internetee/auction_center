require 'test_helper'

class FirstBidFromWishlistServiceTest < ActionDispatch::IntegrationTest
  def setup
    super

    @auction = auctions(:valid_without_offers)
    @english_auction = auctions(:english)
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_should_set_first_bid_from_wishlist
    wishlist_item = WishlistItem.new(domain_name: @auction.domain_name, user: @user, cents: 6000)
    wishlist_item.save
    assert_equal @auction.offers.count, 0

    FirstBidFromWishlistService.apply_bid(auction: @auction)
    @auction.reload

    assert_equal @auction.offers.count, 1
    assert_equal @auction.offers.first.cents, 6000
  end

  def test_no_any_offers_if_there_is_no_any_wishlists_with_bids
    wishlist_item = WishlistItem.new(domain_name: @auction.domain_name, user: @user)
    wishlist_item.save
    assert_equal @auction.offers.count, 0

    FirstBidFromWishlistService.apply_bid(auction: @auction)
    @auction.reload

    assert_equal @auction.offers.count, 0
  end

  def test_can_set_first_bid_if_starting_price_more_that_wishlist_bid
    @english_auction.update(starting_price: 10.0)
    @english_auction.offers.destroy_all
    @english_auction.reload
    wishlist_item = WishlistItem.new(domain_name: @english_auction.domain_name, user: @user, cents: 6000)
    wishlist_item.save
    assert_equal @english_auction.offers.count, 0

    FirstBidFromWishlistService.apply_bid(auction: @english_auction)
    @english_auction.reload

    assert_equal @english_auction.offers.count, 0
  end

  def test_can_set_first_bid_for_english_auction_from_wishlist_bid
    @english_auction.offers.destroy_all
    @english_auction.reload

    wishlist_item = WishlistItem.new(domain_name: @english_auction.domain_name, user: @user, cents: 6000)
    wishlist_item.save(validate: false)

    assert_equal @english_auction.offers.count, 0

    FirstBidFromWishlistService.apply_bid(auction: @english_auction)
    @english_auction.reload

    assert_equal @english_auction.offers.count, 1
    assert_equal @english_auction.offers.first.cents, 6000
  end

  def test_should_be_set_early_bid_if_price_are_same_from_wishlists
    billing_profile = @user_two.billing_profiles.build
    billing_profile.name = 'Private Person'
    billing_profile.street = 'Baker Street 221B'
    billing_profile.city = 'London'
    billing_profile.postal_code = 'NW1 6XE'
    billing_profile.country_code = 'GB'
    billing_profile.save

    wishlist_item = WishlistItem.new(domain_name: @auction.domain_name, user: @user, cents: 6000)
    wishlist_item.save(validate: false)
    wishlist_item = WishlistItem.new(domain_name: @auction.domain_name, user: @user_two, cents: 6000)
    wishlist_item.save(validate: false)

    assert_equal @auction.offers.count, 0

    FirstBidFromWishlistService.apply_bid(auction: @auction)
    @auction.reload

    assert_equal @auction.currently_winning_offer.user, @user
  end

  def test_should_be_set_early_bid_if_price_are_same_from_wishlists_for_english_auction
    billing_profile = @user_two.billing_profiles.build
    billing_profile.name = 'Private Person'
    billing_profile.street = 'Baker Street 221B'
    billing_profile.city = 'London'
    billing_profile.postal_code = 'NW1 6XE'
    billing_profile.country_code = 'GB'
    billing_profile.save

    @english_auction.update(starting_price: 10.0)
    @english_auction.offers.destroy_all
    wishlist_item = WishlistItem.new(domain_name: @english_auction.domain_name, user: @user, cents: 6000)
    wishlist_item.save(validate: false)
    wishlist_item = WishlistItem.new(domain_name: @english_auction.domain_name, user: @user_two, cents: 6000)
    wishlist_item.save(validate: false)

    assert_equal @english_auction.offers.count, 0

    FirstBidFromWishlistService.apply_bid(auction: @english_auction)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.user, @user
  end

  def test_should_be_set_highest_bid_from_wishlist
    billing_profile = @user_two.billing_profiles.build
    billing_profile.name = 'Private Person'
    billing_profile.street = 'Baker Street 221B'
    billing_profile.city = 'London'
    billing_profile.postal_code = 'NW1 6XE'
    billing_profile.country_code = 'GB'
    billing_profile.save

    @english_auction.update(starting_price: 10.0)
    @english_auction.offers.destroy_all
    wishlist_item = WishlistItem.new(domain_name: @english_auction.domain_name, user: @user, cents: 6000)
    wishlist_item.save(validate: false)
    wishlist_item = WishlistItem.new(domain_name: @english_auction.domain_name, user: @user_two, cents: 10000)
    wishlist_item.save(validate: false)

    assert_equal @english_auction.offers.count, 0

    FirstBidFromWishlistService.apply_bid(auction: @english_auction)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.cents, 10000
    assert_equal @english_auction.currently_winning_offer.user, @user_two
  end
end
