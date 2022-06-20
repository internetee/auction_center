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
    bid_in_cents = 500

    @english_auction.update(min_bids_step: 5.1)
    @english_auction.reload
    offer = @english_auction.offers.first
    offer.update(cents: bid_in_cents)
    offer.reload

    assert_equal @english_auction.highest_price.to_f, 5.0

    @autobider.update(user: @user_two)
    @autobider.reload
    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.highest_price.to_f, 5.1
    assert_equal @english_auction.min_bids_step.round(2), 5.2
    assert_equal @english_auction.currently_winning_offer.user, @user_two
  end

  def test_user_cannot_to_outbid_him_self_if_previous_highest_offer_is_him
    bid_in_cents = 500

    @english_auction.update(min_bids_step: 5.1)
    @english_auction.reload
    offer = @english_auction.offers.first
    offer.update(cents: bid_in_cents)
    offer.reload

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
    assert_equal @english_auction.highest_price.to_f, 50.0
    assert_equal @autobider.cents, 20_000 # 200.0
    assert_equal autobider_two.cents, 15_000 # 150.0

    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.highest_price.to_f, 150.0
    assert_equal @english_auction.min_bids_step, 160.0
  end

  def test_if_two_participants_have_same_values_should_be_apply_for_early_record
    autobider_two = Autobider.create(user: @user_two, domain_name: @english_auction.domain_name, cents: 20_000)
    assert autobider_two.created_at < @autobider.created_at # because travel_to in setup method
    assert_equal @autobider.cents, autobider_two.cents

    AutobiderService.autobid(@english_auction)
    @english_auction.reload

    assert_equal @english_auction.currently_winning_offer.user, autobider_two.user
  end

  def test_highest_autobider_should_outbid_penultimate_autobider_value
    @english_auction.reload
    offer = @english_auction.offers.first
    offer.update(user: @user_two)
    offer.reload

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
end
