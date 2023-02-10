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

  def test_restict_for_bid_for_auction_with_enable_deposit
    @auction.offers.destroy_all
    @auction.update(enable_deposit: true, requirement_deposit_in_cents: 5000)
    @auction.reload
    assert @auction.offers.empty?
    assert @auction.enable_deposit?

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
         headers: { "HTTP_REFERER" => root_path }
    assert @auction.offers.empty?
  end

  def test_user_can_made_bid_id_deposit_disable
    @auction.offers.destroy_all
    @auction.update(enable_deposit: false)
    @auction.reload
    assert @auction.offers.empty?
    refute @auction.enable_deposit?

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
         headers: { "HTTP_REFERER" => root_path }
    assert_equal @auction.offers.count, 1
  end

  def test_enable_to_bid_if_you_have_association_with_auction
    @auction.offers.destroy_all
    @auction.update(enable_deposit: true, requirement_deposit_in_cents: 5000)
    @auction.reload
    assert @auction.offers.empty?
    assert @auction.enable_deposit?

    DomainParticipateAuction.create(user_id: @user.id, auction_id: @auction.id)
    @auction.reload
    @user.reload

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
         headers: { "HTTP_REFERER" => root_path }
    assert_equal @auction.offers.count, 1
  end
end
