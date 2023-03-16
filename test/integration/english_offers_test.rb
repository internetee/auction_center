require 'application_system_test_case'

class EnglishOffersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper, ActionCable::TestHelper
  include Turbo::Streams::ActionHelper

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
    
    assert_equal flash[:alert], I18n.t('.english_offers.create.ban')
    assert @auction.offers.empty?
  end

  def test_for_offer_owner_should_be_generated_the_name
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
    assert @auction.offers.last.username.present?
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
         params: params

    assert_equal response.status, 302
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

  def test_create_bid_should_be_broadcasted
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

    clear_enqueued_jobs

    post auction_english_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    assert @auction.offers.present?
    assert_equal @auction.offers.first.cents, 500
    assert_equal @auction.offers.first.user, @user

    updated_signed_name = Turbo::StreamsChannel.signed_stream_name "auctions_offer_#{@auction.id}"
    updated_stream_name = Turbo::StreamsChannel.verified_stream_name updated_signed_name

    list_signed_name = Turbo::StreamsChannel.signed_stream_name 'auctions'
    list_stream_name = Turbo::StreamsChannel.verified_stream_name list_signed_name

    assert_enqueued_jobs 3
    perform_enqueued_jobs

    assert_broadcasts updated_stream_name, 2
    assert_broadcasts list_stream_name, 1
  end

  def test_broadcasted_should_be_skips
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

    clear_enqueued_jobs

    patch english_offer_path(uuid: @auction.offers.first.uuid),
          params: params,
          headers: {}

    @auction.reload

    assert_equal @auction.offers.first.cents, 800
    assert_equal @auction.offers.first.user, @user

    updated_signed_name = Turbo::StreamsChannel.signed_stream_name "auctions_offer_#{@auction.id}"
    updated_stream_name = Turbo::StreamsChannel.verified_stream_name updated_signed_name

    list_signed_name = Turbo::StreamsChannel.signed_stream_name 'auctions'
    list_stream_name = Turbo::StreamsChannel.verified_stream_name list_signed_name

    assert_enqueued_jobs 4
    perform_enqueued_jobs

    assert_broadcasts updated_stream_name, 2
    assert_broadcasts list_stream_name, 2
  end

  def test_multiple_users_can_set_bids
    10.times do |i|
      u = User.create(
        email: "user_t#{i}@auction.test",
        password: "password123",
        alpha_two_country_code: 'LV',
        identity_code: nil,
        given_names: 'Joe John',
        surname: 'Participant',
        confirmed_at: Time.parse("2010-07-05 00:16:00 UTC"),
        created_at: Time.parse("2010-07-05 00:16:00 UTC"),
        mobile_phone: "+37255000#{i}",
        mobile_phone_confirmation_code: "0000",
        mobile_phone_confirmed_at: Time.parse("2010-07-05 00:17:00 UTC"),
        roles: ['participant'],
        terms_and_conditions_accepted_at: Time.parse("2010-07-05 00:16:00 UTC"),
        locale: 'en',
      )

      BillingProfile.create_default_for_user(u.id)
      u.reload
    end

    assert_equal User.count, 14

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

    sign_out @user

    10.times do |i|
      user = User.last(10).sample

      sign_in user

      params = {
        offer: {
          auction_id: @auction.id,
          user_id: user.id,
          price: (10.0 * (i + 1)).to_f,
          billing_profile_id: user.billing_profiles.first.id
        }
      }

      post auction_english_offers_path(auction_uuid: @auction.uuid),
           params: params,
           headers: {}

      @auction.reload
      sign_out user
    end

    assert_equal @auction.currently_winning_offer.cents, 10_000
  end

  def test_should_return_an_error_if_bid_out_of_range
    minimum_offer = Setting.find_by(code: 'auction_minimum_offer').retrieve
    assert_equal minimum_offer, 500

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: (2**31 + 1).to_f,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_english_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: {}

    assert_equal response.status, 302

    @auction.reload
    assert @auction.offers.empty?
  end
end
