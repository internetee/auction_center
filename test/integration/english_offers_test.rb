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

    stub_request(:any, /eis_billing_system/)
      .to_return(status: 200, body: "{\"reference_number\":\"#{rand(111..999)}\"}", headers: {})

    travel_to Time.parse('2010-07-05 11:30 +0000').in_time_zone
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
         headers: { "HTTP_REFERER" => root_path }

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

    post auction_english_offers_path(auction_uuid: @auction.uuid), params: params

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
          headers: { "HTTP_REFERER" => root_path }

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
          headers: { "HTTP_REFERER" => root_path }

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

    post auction_english_offers_path(auction_uuid: @auction.uuid), params: params
    
    assert_equal flash[:alert], I18n.t('english_offers.create.ban')
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
                                     headers: { "HTTP_REFERER" => root_path }
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
         params: params,
         headers: { "HTTP_REFERER" => root_path }

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
         headers: { "HTTP_REFERER" => root_path }

    assert @auction.offers.present?
    assert_equal @auction.offers.first.cents, 500
    assert_equal @auction.offers.first.user, @user

    updated_signed_name = Turbo::StreamsChannel.signed_stream_name "auctions_offer_#{@auction.id}"
    updated_stream_name = Turbo::StreamsChannel.verified_stream_name updated_signed_name

    list_signed_name = Turbo::StreamsChannel.signed_stream_name 'auctions'
    list_stream_name = Turbo::StreamsChannel.verified_stream_name list_signed_name

    # assert_enqueued_jobs 3
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
          headers: { "Referer" => "http://example.com" }

    @auction.reload

    assert_equal @auction.offers.first.cents, 800
    assert_equal @auction.offers.first.user, @user

    updated_signed_name = Turbo::StreamsChannel.signed_stream_name "auctions_offer_#{@auction.id}"
    updated_stream_name = Turbo::StreamsChannel.verified_stream_name updated_signed_name

    list_signed_name = Turbo::StreamsChannel.signed_stream_name 'auctions'
    list_stream_name = Turbo::StreamsChannel.verified_stream_name list_signed_name

    # assert_enqueued_jobs 4
    perform_enqueued_jobs

    assert_broadcasts updated_stream_name, 2
    assert_broadcasts list_stream_name, 2
  end

  def test_broadcast_notifications_when_made_bid
    assert @auction.offers.empty?
    assert_equal @user.notifications.count, 0
    assert_equal @user_two.notifications.count, 0

    BillingProfile.create_default_for_user(@user_two.id)
    @user_two.reload

    Offer.create!(
      auction: @auction,
      user: @user_two,
      cents: 100_0,
      billing_profile: @user_two.billing_profiles.first
    )

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 100_00,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_english_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: { "Referer" => "http://example.com" }

    @user.reload && @user_two.reload

    assert_equal @user.notifications.count, 0
    assert_equal @user_two.notifications.count, 1

    notify_signed_name = Turbo::StreamsChannel.signed_stream_name [@user_two, :flash]
    notify_stream_name = Turbo::StreamsChannel.verified_stream_name notify_signed_name

    perform_enqueued_jobs

    assert_broadcasts notify_stream_name, 1
  end

  def test_multiple_users_can_set_bids
    10.times do |i|
      u = User.new(
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

      u.save && u.reload

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
         headers: { "Referer" => "http://example.com" }

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
           headers: { "Referer" => "http://example.com" }

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
         params: params, headers: { "Referer" => "http://example.com" }

    assert_equal response.status, 302

    @auction.reload
    assert @auction.offers.empty?
  end

  def test_participants_should_receive_notfication_if_someone_outbid_by_creating
    assert @auction.offers.empty?
    assert_equal @user.notifications.count, 0
    assert_equal @user_two.notifications.count, 0

    BillingProfile.create_default_for_user(@user_two.id)
    @user_two.reload

    Offer.create!(
      auction: @auction,
      user: @user_two,
      cents: 100_0,
      billing_profile: @user_two.billing_profiles.first
    )

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 100_00,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    post auction_english_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: { "Referer" => "http://example.com" }

    @user.reload && @user_two.reload

    assert_equal @user.notifications.count, 0
    assert_equal @user_two.notifications.count, 1
  end

  def test_participants_should_receive_notfication_if_someone_outbid_by_updating
    assert @auction.offers.empty?
    assert_equal @user.notifications.count, 0
    assert_equal @user_two.notifications.count, 0

    BillingProfile.create_default_for_user(@user_two.id)
    @user_two.reload

    Offer.create!(
      auction: @auction,
      user: @user,
      cents: 100_0,
      billing_profile: @user.billing_profiles.first
    )

    Offer.create!(
      auction: @auction,
      user: @user_two,
      cents: 120_0,
      billing_profile: @user_two.billing_profiles.first
    )

    @user.reload && @user_two.reload
    assert_equal @user.notifications.count, 0
    assert_equal @user_two.notifications.count, 0

    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 160.0,
        billing_profile_id: @user.billing_profiles.first.id
      }
    }

    clear_enqueued_jobs

    patch english_offer_path(uuid: @auction.offers.first.uuid),
          params: params,
          headers: { "Referer" => "http://example.com" }

    @user.reload && @user_two.reload

    assert_equal @user.notifications.count, 0
    assert_equal @user_two.notifications.count, 1
  end


  def test_notification_should_receive_only_participant_who_bid_was_overbidded
    assert @auction.offers.empty?

    5.times do |i|
      u = User.new(
        email: "user_t#{i}@auction.test",
        password: "password123",
        alpha_two_country_code: 'LV',
        identity_code: nil,
        given_names: 'Joe John',
        surname: 'Participant',
        confirmed_at: Time.zone.now,
        created_at: Time.zone.now - 1.minute,
        mobile_phone: "+37255000#{i}",
        mobile_phone_confirmation_code: "0000",
        mobile_phone_confirmed_at: Time.zone.now - 1.minute,
        roles: ['participant'],
        terms_and_conditions_accepted_at: Time.zone.now - 1.minute,
        locale: 'en',
      )

      u.save && u.reload
      b = BillingProfile.create_default_for_user(u.id)

      params = {
        offer: {
          auction_id: @auction.id,
          user_id: u.id,
          price: "1#{i}.0".to_i,
          billing_profile_id:b.id
        }
      }

      sign_in u
  
      post auction_english_offers_path(auction_uuid: @auction.uuid),
           params: params,
           headers: { "Referer" => "http://example.com" }

      u.reload && @auction.reload

      sign_out u
    end

    five_last_users = User.last(5)

    4.times do |i|
      assert_equal five_last_users[i].notifications.count, 1
    end

    assert_equal five_last_users.last.notifications.count, 0

    assert_equal @user.notifications.count, 0
    params = {
      offer: {
        auction_id: @auction.id,
        user_id: @user.id,
        price: 20.0,
        billing_profile_id:@user.billing_profiles.first.id
      }
    }

    stub_request(:post, "https://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator")
      .to_return(status: 200, body: "{\"reference_number\":\"#{rand(100000..999999)}\"}", headers: {})

    sign_in @user

    post auction_english_offers_path(auction_uuid: @auction.uuid),
         params: params,
         headers: { "Referer" => "http://example.com" }

    @auction.reload && five_last_users.last.reload

    assert_equal five_last_users.last.notifications.count, 1
    assert_equal @user.notifications.count, 0
  end
end
