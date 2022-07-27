require 'test_helper'

class AutobiderServiceTest < ActionDispatch::IntegrationTest
  def setup
    super

    @auction = auctions(:valid_without_offers)
    @english_auction = auctions(:english)
    @user = users(:participant)
    @user_two = users(:second_place_participant)

    billing_profile = @user_two.billing_profiles.build
    billing_profile.name = 'Private Person'
    billing_profile.street = 'Baker Street 221B'
    billing_profile.city = 'London'
    billing_profile.postal_code = 'NW1 6XE'
    billing_profile.country_code = 'GB'
    billing_profile.save

    @autobider = autobiders(:one)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_if_offer_of_another_user_is_exist_autobidder_should_outbid
    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user_two
    offer.cents = 500
    offer.billing_profile = @user_two.billing_profiles.first
    offer.save!
    @english_auction.update_minimum_bid_step(5.1)

    @english_auction.reload

    AutobiderService.autobid(@english_auction)

    assert_equal @english_auction.highest_price.to_f, 5.2
    assert_equal @english_auction.min_bids_step, 5.3
    assert_equal @autobider.user, @user
    assert_equal @english_auction.currently_winning_offer.user, @user
  end

  def test_user_cannot_to_outbid_him_self_if_previous_highest_offer_is_him
    bid_in_cents = 500

    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user
    offer.cents = bid_in_cents
    offer.billing_profile = @user_two.billing_profiles.first
    offer.save!

    @english_auction.update_minimum_bid_step(5.0)
    @english_auction.reload

    assert_equal offer.user, @user
    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.highest_price.to_f, 5.0
    assert_equal @english_auction.min_bids_step, 5.1
    assert_equal @english_auction.currently_winning_offer.user, @user
  end

  def test_create_first_bid_as_starting_price_if_no_any_offers
    @english_auction.offers.destroy_all
    @english_auction.reload

    assert_equal @english_auction.offers.count, 0

    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.offers.count, 1
    assert_equal @english_auction.highest_price.to_f, @english_auction.starting_price
    assert_equal @english_auction.offers.first.user, @user
  end

  def test_no_new_offer_if_starting_price_more_than_autobider_value
    @english_auction.offers.destroy_all
    @english_auction.update(starting_price: 25.0)
    @english_auction.reload

    @autobider.update(cents: 1_000)
    @autobider.reload

    assert_equal @english_auction.offers.count, 0

    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.offers.count, 0
  end

  def test_if_two_participants_have_autobiders_should_be_sets_penultimate_value
    autobider_two = Autobider.create(user: @user_two, domain_name: @english_auction.domain_name, cents: 15_000)

    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user
    offer.cents = 500
    offer.billing_profile = @user_two.billing_profiles.first
    offer.save!

    assert_equal @english_auction.highest_price.to_f, 5.0
    assert_equal @autobider.cents, 20_000 # 200.0
    assert_equal autobider_two.cents, 15_000 # 150.0

    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.highest_price.to_f, 160.0
    assert_equal @english_auction.min_bids_step, 170.0
  end

  def test_if_two_participants_have_same_values_should_be_apply_for_early_record
    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user
    offer.cents = 500
    offer.billing_profile = @user_two.billing_profiles.first
    offer.save!

    autobider_two = Autobider.create(user: @user_two, domain_name: @english_auction.domain_name, cents: 20_000)
    assert_equal @autobider.cents, autobider_two.cents

    @autobider.update(updated_at: Time.zone.now - 20.minutes)
    @autobider.reload
    autobider_two.update(updated_at: Time.zone.now - 10.minutes)
    autobider_two.reload

    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.user, @autobider.user
  end

  def test_highest_autobider_should_outbid_penultimate_autobider_value
    @english_auction.reload

    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user_two
    offer.cents = 500
    offer.billing_profile = @user_two.billing_profiles.first
    offer.save!

    Autobider.create(user: @user_two, domain_name: @english_auction.domain_name, cents: 15_000)
    # @autobider.update(created_at: autobider_two.created_at - 1.day) # because travel_to in setup method
    @autobider.reload

    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.cents, 16_000
    assert_equal @english_auction.currently_winning_offer.user, @autobider.user
  end

  def test_no_apply_for_blind_auction
    autobider_two = Autobider.create(user: @user_two, domain_name: @auction.domain_name, cents: 20_000)
    autobider_two.reload

    assert_equal @auction.offers.count, 0
    @auction.update(platform: 'blind')
    @auction.reload

    AutobiderService.autobid(@auction)
    @auction.reload

    assert_equal @auction.offers.count, 0
  end

  def test_autobidder_should_set_higher_bid
    # set autobidder to 4 with user1 and 3,99 with user2. current price was 2,99, next min price 3,09. Price was raised to 3,19 for the user1. Correct results is current price of 4 for the U1 as they had set their autobidder value higher
    Autobider.destroy_all
    @english_auction.offers.destroy_all
    @english_auction.update(min_bids_step: 1.0)
    @english_auction.update(starting_price: 1.0)
    @english_auction.reload
    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user
    offer.cents = 299
    offer.billing_profile = @user.billing_profiles.first
    offer.save!
    offer.reload

    @english_auction.update(min_bids_step: 3.09)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.cents, 299
    assert_equal @english_auction.min_bids_step, 3.09

    Autobider.create(user: @user_two, domain_name: @english_auction.domain_name, cents: 399)
    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    Autobider.create(user: @user, domain_name: @english_auction.domain_name, cents: 400)
    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.cents, 400
  end

  def test_with_equal_bid_offer_should_be_who_set_first
    #   set autobidder to 4 with user1 and did the same with user2. Current price 3,19, next min price 3,29. User1 had the highest bid. Nothing changed when U2 set its autobidder to 4 - current price was not changed. Whilst the correct result would have been 4.0 highest offer for U1 as they set their autobidder first at 4
    Autobider.destroy_all
    @english_auction.offers.destroy_all
    @english_auction.update(min_bids_step: 1.0)
    @english_auction.update(starting_price: 1.0)
    @english_auction.reload

    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user
    offer.cents = 319
    offer.billing_profile = @user.billing_profiles.first
    offer.save!
    offer.reload
    offer.update(updated_at: Time.zone.now - 2.minute)
    offer.reload

    @english_auction.update(min_bids_step: 3.29)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.cents, 319
    assert_equal @english_auction.min_bids_step, 3.29

    Autobider.create(user: @user_two, domain_name: @english_auction.domain_name, cents: 400)
    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    Autobider.create(user: @user, domain_name: @english_auction.domain_name, cents: 400)
    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.user, @user_two
    assert_equal @english_auction.currently_winning_offer.cents, 400
  end

  def test_should_be_set_actual_highest_value_from_autobidder
    # still not OK. set autobidder on one user to 2.0 current price1,8. Another user made a bid for 1,99 - internal error! going back revealed that the autobid failed and the 2nd users 1,99 was set as the new highest bid.
    Autobider.destroy_all
    @english_auction.offers.destroy_all
    @english_auction.update(min_bids_step: 1.0)
    @english_auction.update(starting_price: 1.0)
    @english_auction.reload

    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user
    offer.cents = 180
    offer.billing_profile = @user.billing_profiles.first
    offer.save!
    offer.reload
    offer.update(updated_at: Time.zone.now - 2.minute)
    offer.reload

    @english_auction.update_minimum_bid_step(1.8)
    @english_auction.reload

    Autobider.create(user: @user, domain_name: @english_auction.domain_name, cents: 200)

    offer = Offer.new
    offer.auction = @english_auction
    offer.user = @user_two
    offer.cents = 199
    offer.billing_profile = @user.billing_profiles.last
    offer.save!
    offer.reload
    offer.update(updated_at: Time.zone.now - 1.minute)
    offer.reload

    @english_auction.update_minimum_bid_step(offer.cents)
    @english_auction.reload

    AutobiderService.autobid(@english_auction)
    @english_auction.reload
    @english_auction.offers.first.reload
    @english_auction.offers.last.reload

    assert_equal @english_auction.currently_winning_offer.cents, 200
  end

  def test_autobider_should_change_ends_at_if_bid_set_in_slipping_time
    @english_auction.update(ends_at: Time.zone.now + 3.minute)
    @english_auction.reload

    assert_equal @english_auction.ends_at, Time.zone.now + 3.minute
    assert_equal @english_auction.slipping_end, 5

    AutobiderService.autobid(@english_auction)
    assert_equal @english_auction.ends_at, Time.zone.now + 5.minute
  end
end
