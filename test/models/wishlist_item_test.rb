require 'test_helper'

class WishlistItemTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
  end

  def test_validatation
    wishlist_item = WishlistItem.new

    refute(wishlist_item.valid?)
    assert_equal(["can't be blank"], wishlist_item.errors[:domain_name])
    assert_equal(["can't be blank"], wishlist_item.errors[:domain_name])
    assert_equal(["must exist"], wishlist_item.errors[:user])
    assert_equal(["can't be blank"], wishlist_item.errors[:valid_until])
  end
end
