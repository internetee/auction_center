require 'test_helper'

class WishlistItemTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
  end

  def test_number_of_items_for_user
    wishlist_item = WishlistItem.new
    assert_equal(0, wishlist_item.number_of_items_for_user)

    wishlist_item.user = @user
    assert_equal(0, wishlist_item.number_of_items_for_user)

    wishlist_item.domain_name = 'example.test'
    wishlist_item.save

    assert_equal(1, wishlist_item.number_of_items_for_user)
  end

  def test_cannot_exceed_the_limit
    setting = settings(:wishlist_size)

    setting.update!(value: '1')
    WishlistItem.create!(user: @user, domain_name: 'dupe.test')

    item = WishlistItem.new(user: @user, domain_name: 'invalid.test')
    item.save

    assert_not(item.valid?)
    assert_equal(['has too many items'], item.errors[:wishlist])
  end

  def test_domain_name_is_automatically_converted_to_unicode
    item = WishlistItem.new(user: @user, domain_name: 'xn--un-bka.ee')
    item.validate

    assert_equal('õun.ee', item.domain_name)
  end

  def test_user_must_exist
    item = WishlistItem.new(user: @user, domain_name: 'dupe.test')
    assert(item.valid?)

    item.user_id = SecureRandom.random_number(10_000)
    assert_not(item.valid?)
    assert_equal(['must exist'], item.errors[:user])
  end

  def test_domain_name_must_be_unique_for_a_user
    WishlistItem.create!(user: @user, domain_name: 'dupe.test')
    item = WishlistItem.new(user: @user, domain_name: 'dupe.test')

    assert_not(item.valid?)
    assert_equal(['is already in your wishlist'], item.errors[:domain_name])
  end

  def test_domain_name_must_be_a_valid_domain
    # This should be a generative test in the future.
    item = WishlistItem.new(user: @user, domain_name: 'dupe.test')
    assert(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: "#{SecureRandom.hex}.test")
    assert(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: 'üõöä.test')
    assert(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: 'some')
    assert_not(item.valid?)
    assert_equal(['is invalid'], item.errors[:domain_name])
  end

  def test_domain_has_valid_extension
    supported_extensions = ["ee", "pri.ee", "com.ee", "med.ee", "fie.ee"]
    setting = settings(:application_name)
    setting.update!(code: :wishlist_supported_domain_extensions, value: supported_extensions)

    item = WishlistItem.new(user: @user, domain_name: 'dupe.ee')
    assert(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: "123.pri.ee")
    assert(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: 'üõöä.med.ee')
    assert(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: 'foo.bar')
    assert_not(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: 'foo.')
    assert_not(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: 'test.pri')
    assert_not(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: 'test.pri.ee.')
    assert_not(item.valid?)
  end

  def test_domain_is_autocompleted_with_default_extension
    setting = settings(:application_name)
    setting.update!(code: :wishlist_default_domain_extension, value: 'ee')

    item = WishlistItem.new(user: @user, domain_name: 'noep')
    assert(item.valid?)
    assert_equal('noep.ee', item.domain_name)

    item = WishlistItem.new(user: @user, domain_name: 'korras.pri.ee')
    assert(item.valid?)
    assert_equal('korras.pri.ee', item.domain_name)

    item = WishlistItem.new(user: @user, domain_name: 'üõöä.med.')
    assert_not(item.valid?)

    item = WishlistItem.new(user: @user, domain_name: 'peppa-pig')
    assert(item.valid?)
    assert_equal('peppa-pig.ee', item.domain_name)
  end
end
