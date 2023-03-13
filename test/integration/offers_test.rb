require 'application_system_test_case'

class OffersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    @auction = auctions(:valid_without_offers)
    @user.reload
    sign_in @user

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def test_user_can_create_a_bid
    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 6.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    assert @auction.offers.present?
    assert_equal @auction.offers.first.cents, 600
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

    post auction_offers_path(auction_uuid: @auction.uuid),
                                     params: params,
                                     headers: {}
    
    assert_equal flash[:alert], I18n.t('.offers.create.ban')
    assert @auction.offers.empty?
  end

  def test_another_user_can_create_a_bid
    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 6.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    @auction.reload

    sign_out @user
    sign_in @user_two

    billing_profile = billing_profiles(:company)

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user_two.id,
        price: 10.0,
        billing_profile_id: billing_profile.id
      }
    }

    post auction_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    @auction.reload

    assert_equal @auction.offers.count, 2
    assert_equal @auction.currently_winning_offer.cents, 1000
    assert_equal @auction.currently_winning_offer.user, @user_two
  end

  def test_user_cannot_bid_less_than_requirement
    minimum_offer = Setting.find_by(code: 'auction_minimum_offer').retrieve
    assert_equal minimum_offer, 500

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 3.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    @auction.reload
    assert @auction.offers.empty?
  end

  def test_user_can_update_his_bid
    minimum_offer = Setting.find_by(code: 'auction_minimum_offer').retrieve
    assert_equal minimum_offer, 500

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 10.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    @auction.reload
    assert_equal @auction.offers.count, 1
    offer = @auction.offers.first

    params = {
      offer: {
        price: 15.0,
      }
    }

    patch offer_path(uuid: offer.uuid), params: params
    offer.reload

    assert_equal offer.cents, 1500
  end
end
