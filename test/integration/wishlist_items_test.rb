require 'application_system_test_case'

class WishlistItemsIntegrationTest < ActionDispatch::IntegrationTest
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

  def test_should_be_returned_ok_code
    get wishlist_items_path

    assert_equal response.code, '200'
  end

  def test_user_can_create_wishlist_item
    assert_equal WishlistItem.count, 0

    params = {
      wishlist_item: {
        user_id: @user.id,
        domain_name: 'dodo.ee',
        price: 20.0
      }
    }

    assert_difference -> { WishlistItem.count } do
      post wishlist_items_path, params: params, headers: {}
    end
  end

  def test_cannot_create_wishlist_item_for_active_auction
    assert_equal WishlistItem.count, 0
    @auction.ends_at = @auction.ends_at + 10.days
    @auction.starts_at = @auction.starts_at - 1.day
    @auction.save
    @auction.reload

    assert @auction.in_progress?

    params = {
      wishlist_item: {
        user_id: @user.id,
        domain_name: @auction.domain_name,
        price: 20.0
      }
    }

    assert_no_difference -> { WishlistItem.count } do
      post wishlist_items_path, params: params, headers: {}
    end
  end

  def test_cannot_create_wishlist_item_for_incorrect_domain_extension
    assert_equal WishlistItem.count, 0

    params = {
      wishlist_item: {
        user_id: @user.id,
        domain_name: 'dodo.dodo',
        price: 20.0
      }
    }

    setting = Setting.find_by_code(:wishlist_supported_domain_extensions)
    setting.update!(value: ['ee'])

    assert_no_difference -> { WishlistItem.count } do
      post wishlist_items_path, params: params, headers: {}
    end
  end

  def test_cannot_create_domain_if_it_unavailable_from_registry
  #   payload = {
  #     avail: 1
  #   }
  #   stub_request(:get, "http://registry3000/api/v1/auctions/avilability_check?domain_name=awesome.ee")
  #     .to_return(status: 200, body: payload.to_json, headers: {})

  #   params = {
  #     wishlist_item: {
  #       user_id: @user.id,
  #       domain_name: 'dodo.dodo',
  #       price: 20.0
  #     }
  #   }

  #   assert_no_difference -> { WishlistItem.count } do
  #     post wishlist_items_path, params: params, headers: {}
  #   end
  end

  def test_can_update_wishlist_item
    # wishlist_item PATCH           /wishlist_items/:uuid
  end

  def test_user_can_delete_wishlist_item
    # wishlist_item DELETE          /wishlist_items/:uuid
  end
end
