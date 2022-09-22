require 'application_system_test_case'

class AutobiderIntegrationTest < ActionDispatch::IntegrationTest
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

  def test_should_create_autobider_for_english_domain
    params = {
      autobider: {
        user_id: @user.id,
        domain_name: @auction.domain_name,
        price: 10.0
      }
    }

    assert_difference -> { Autobider.count } do
      post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }
      @user.reload
    end
  end

  def test_autobider_creation_should_init_offer
    params = {
      autobider: {
        user_id: @user.id,
        domain_name: @auction.domain_name,
        price: 10.0
      }
    }

    assert @auction.offers.empty?
    post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }
    @user.reload
    @auction.reload

    assert_equal @auction.offers.first.cents,
                 Money.from_amount(@auction.starting_price.to_f).cents
  end

  def test_autobider_creation_should_outbid_existed_offer
    params = {
      autobider: {
        user_id: @user.id,
        domain_name: @auction.domain_name,
        price: 10.0
      }
    }

    starting_price = Money.from_amount(@auction.starting_price.to_f).cents

    assert @auction.offers.empty?

    Offer.create!(
      auction: @auction,
      user: @user_two,
      cents: starting_price,
      billing_profile: @user.billing_profiles.first
    )

    @auction.reload

    @auction.update_minimum_bid_step(@auction.min_bids_step)
    assert @auction.offers.present?
    assert_equal @auction.currently_winning_offer.cents, 500

    post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }
    @user.reload
    @auction.reload

    assert_equal @auction.offers.count, 2
    assert_equal @auction.currently_winning_offer.cents, 510
  end

  def test_autobider_can_be_updated
    params = {
      autobider: {
        user_id: @user.id,
        domain_name: @auction.domain_name,
        price: 10.0
      }
    }

    post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }

    autobider = Autobider.last
    assert_equal autobider.cents, 1000

    put autobider_path(uuid: autobider.uuid), params: { autobider: { domain_name: @auction.domain_name,
                                                                     price: 12.0 } },
                                              headers: { "HTTP_REFERER" => root_path }
    autobider.reload

    assert_equal autobider.cents, 1200
  end

  # def test_updated_autobider_can_outbid_existed_offer
  #   params = {
  #     autobider: {
  #       user_id: @user.id,
  #       domain_name: @auction.domain_name,
  #       price: 6.0
  #     }
  #   }
  #   assert @auction.offers.empty?
  #   post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }
  #   @auction.reload

  #   autobider = Autobider.last
  #   assert_equal autobider.cents, 600
  #   assert @auction.offers.present?
  #   assert_equal @auction.currently_winning_offer.cents, 500

  #   Offer.create!(
  #     auction: @auction,
  #     user: @user_two,
  #     cents: @auction.currently_winning_offer.cents + 110,
  #     billing_profile: @user.billing_profiles.first
  #   )

  #   @auction.reload
  #   @auction.update_minimum_bid_step(@auction.min_bids_step)
  #   assert_equal @auction.currently_winning_offer.cents, 610

  #   p '----'
  #   p @auction.offers
  #   p '-----'

  #   put autobider_path(uuid: autobider.uuid), params: { autobider: { cents: 700, domain_name: autobider.domain_name } },
  #                                             headers: { "HTTP_REFERER" => root_path }
  #   autobider.reload

  #   p '----'
  #   p @auction.offers
  #   p '-----'
  #   # assert_equal @auction.currently_winning_offer.cents, 610
  # end
end
