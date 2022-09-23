require 'application_system_test_case'

class EnglishOffersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    @auction = auctions(:english)
    @user.autobiders.destroy_all
    @user.reload
    sign_in @user

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def test_user_can_create_a_bid
    @auction.offers.destroy_all
    @auction.reload
    assert @auction.offers.empty?

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 5.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_english_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    assert @auction.offers.present?
    assert_equal @auction.offers.first.cents, 500
    assert_equal @auction.offers.first.user, @user
  end

  def test_user_cannot_create_bid_less_than_starting_price
    @auction.offers.destroy_all
    @auction.reload
    assert @auction.offers.empty?

    assert_equal @auction.starting_price, 5.0

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 4.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_english_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    assert @auction.offers.empty?
  end

  def test_user_can_update_existed_bid
    starting_price = Money.from_amount(@auction.starting_price.to_f).cents

    Offer.create!(
      auction: @auction,
      user: @user,
      cents: starting_price,
      billing_profile: @user.billing_profiles.first
    )

    assert @auction.offers.present?
    assert_equal @auction.offers.first.user, @user
    assert_equal @auction.offers.first.cents, 500

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 8.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    patch english_offer_path(uuid: @auction.offers.first.uuid),
          params: params,
          headers: {}

    @auction.reload

    assert_equal @auction.offers.first.cents, 800
    assert_equal @auction.offers.first.user, @user
  end

  def test_user_cannot_update_bid_to_smaller_value
    starting_price = Money.from_amount(@auction.starting_price.to_f).cents

    Offer.create!(
      auction: @auction,
      user: @user,
      cents: starting_price,
      billing_profile: @user.billing_profiles.first
    )

    assert @auction.offers.present?
    assert_equal @auction.offers.first.user, @user
    assert_equal @auction.offers.first.cents, 500

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 3.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    patch english_offer_path(uuid: @auction.offers.first.uuid),
          params: params,
          headers: {}

    @auction.reload

    assert_equal @auction.offers.first.cents, 500
    assert_equal @auction.offers.first.user, @user
  end

  def test_banned_user_cannot_create_an_offer
    @auction.offers.destroy_all
    @auction.reload
    assert @auction.offers.empty?

    valid_from = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    Ban.create!(user: @user,
                domain_name: @auction.domain_name,
                valid_from: valid_from, valid_until: valid_from + 3.days)

    @user.reload
    assert @user.banned?

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 7.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_english_offers_path(auction_uuid: @auction.uuid),
                                     params: params,
                                     headers: {}
    assert @auction.offers.empty?
  end
end
