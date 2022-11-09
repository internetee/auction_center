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

  # def test_should_create_autobider_for_english_domain
  #   params = {
  #     autobider: {
  #       user_id: @user.id,
  #       domain_name: @auction.domain_name,
  #       price: 10.0
  #     }
  #   }

  #   assert_difference -> { Autobider.count } do
  #     post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }
  #     @user.reload
  #   end
  # end

  # def test_autobider_creation_should_init_offer
  #   params = {
  #     autobider: {
  #       user_id: @user.id,
  #       domain_name: @auction.domain_name,
  #       price: 10.0
  #     }
  #   }

  #   assert @auction.offers.empty?
  #   post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }
  #   @user.reload
  #   @auction.reload

  #   assert_equal @auction.offers.first.cents,
  #                Money.from_amount(@auction.starting_price.to_f).cents
  # end

  # def test_autobider_creation_should_outbid_existed_offer
  #   params = {
  #     autobider: {
  #       user_id: @user.id,
  #       domain_name: @auction.domain_name,
  #       price: 10.0
  #     }
  #   }

  #   starting_price = Money.from_amount(@auction.starting_price.to_f).cents

  #   assert @auction.offers.empty?

  #   Offer.create!(
  #     auction: @auction,
  #     user: @user_two,
  #     cents: starting_price,
  #     billing_profile: @user.billing_profiles.first
  #   )

  #   @auction.reload

  #   @auction.update_minimum_bid_step(@auction.min_bids_step)
  #   assert @auction.offers.present?
  #   assert_equal @auction.currently_winning_offer.cents, 500

  #   post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }
  #   @user.reload
  #   @auction.reload

  #   assert_equal @auction.offers.count, 2
  #   assert_equal @auction.currently_winning_offer.cents, 510
  # end

  # def test_autobider_can_be_updated
  #   params = {
  #     autobider: {
  #       user_id: @user.id,
  #       domain_name: @auction.domain_name,
  #       price: 10.0
  #     }
  #   }

  #   post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }

  #   autobider = Autobider.last
  #   assert_equal autobider.cents, 1000

  #   put autobider_path(uuid: autobider.uuid), params: { autobider: { domain_name: @auction.domain_name,
  #                                                                    price: 12.0 } },
  #                                             headers: { "HTTP_REFERER" => root_path }
  #   autobider.reload

  #   assert_equal autobider.cents, 1200
  # end

  def test_banned_user_cannot_set_the_autobider
    params = {
      autobider: {
        user_id: @user.id,
        domain_name: @auction.domain_name,
        price: 10.0
      }
    }

    valid_from = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    Ban.create!(user: @user,
                domain_name: @auction.domain_name,
                valid_from: valid_from, valid_until: valid_from + 3.days)

    @user.reload
    assert @user.banned?

    assert_no_difference -> { Autobider.count } do
      post autobider_index_path, params: params, headers: { "HTTP_REFERER" => root_path }
      @user.reload
    end
  end
end
