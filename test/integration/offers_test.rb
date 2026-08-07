require 'test_helper'

class OffersAuctionFlowTest < ActionDispatch::IntegrationTest
  OFFER_COUNT = 'Offer.count'

  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    @auction = auctions(:valid_without_offers)
    @user.reload
    sign_in @user


    Recaptcha.configuration.skip_verify_env.push('test')
    travel_to Time.parse('2010-07-05 11:30 +0000').in_time_zone
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

  def test_should_return_an_error_if_bid_out_of_range
    minimum_offer = Setting.find_by(code: 'auction_minimum_offer').retrieve
    assert_equal minimum_offer, 500

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 2**31 + 1,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    assert_equal response.status, 303

    @auction.reload
    assert @auction.offers.empty?
  end

  def test_second_create_redirects_when_offer_already_exists
    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 6.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_offers_path(auction_uuid: @auction.uuid), params: params
    assert_equal 1, @auction.reload.offers.count

    post auction_offers_path(auction_uuid: @auction.uuid), params: params
    assert_redirected_to root_path
    assert_equal I18n.t('offers.already_exists'), flash[:notice]
    assert_equal 1, @auction.reload.offers.count
  end

  def test_show_offer
    offer = offers(:minimum_offer)
    sign_in users(:second_place_participant)

    get offer_path(uuid: offer.uuid)
    assert_response :success
  end

  def test_delete_confirmation_page
    offer = offers(:minimum_offer)
    sign_in users(:second_place_participant)

    get "/offers/#{offer.uuid}/delete"
    assert_response :success
  end

  def test_update_redirects_when_auction_not_in_progress
    offer = offers(:expired_offer)
    sign_out @user
    sign_in users(:participant)

    get edit_offer_path(uuid: offer.uuid)
    assert_redirected_to root_path

    patch offer_path(uuid: offer.uuid), params: { offer: { price: 99.0 } }
    assert_redirected_to root_path
  end

  def test_destroy_blind_offer_when_modifiable
    offer = Offer.create!(
      auction: @auction,
      user: @user,
      cents: 600,
      billing_profile: @user.billing_profiles.first
    )
    assert offer.auction.in_progress?

    assert_difference(OFFER_COUNT, -1) do
      delete offer_path(uuid: offer.uuid)
    end
    assert_redirected_to auctions_path
  end

  def test_destroy_blind_offer_when_not_modifiable_redirects
    offer = offers(:expired_offer)
    assert_not offer.auction.in_progress?

    assert_no_difference(OFFER_COUNT) do
      delete offer_path(uuid: offer.uuid)
    end
    assert_redirected_to offer_path(uuid: offer.uuid)
  end

  def test_destroy_responds_with_no_content_for_json
    offer = Offer.create!(
      auction: @auction,
      user: @user,
      cents: 700,
      billing_profile: @user.billing_profiles.first
    )

    assert_difference(OFFER_COUNT, -1) do
      delete offer_path(uuid: offer.uuid), as: :json
    end
    assert_response :no_content
  end
end
