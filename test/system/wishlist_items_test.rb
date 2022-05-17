require 'application_system_test_case'

class WishlistItemsTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
    @wishlist_item = WishlistItem.create!(user: @user, domain_name: 'example.test')

    sign_in(@user)
    visit(wishlist_items_path)
  end

  def test_user_see_a_list_of_wishlist_items
    assert(page.has_text?('example.test'))
  end

  def test_user_can_delete_existing_items
    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_text?('Deleted successfully.'))
  end

  def test_user_can_add_new_item
    fill_in('wishlist_item[domain_name]', with: 'new-item.test')
    click_link_or_button('Submit')

    assert(page.has_css?('div.notice', text: 'Created successfully.'))
  end

  def test_punycode_items_are_converted_to_unicode
    fill_in('wishlist_item[domain_name]', with: 'xn--un-bka.ee')
    click_link_or_button('Submit')

    assert(page.has_css?('div.notice', text: 'Created successfully.'))
    assert(page.has_text?('õun.ee'))
  end

  def test_user_cannot_create_wishlist_items_in_the_name_of_other_user
    other_user = users(:second_place_participant)

    fill_in('wishlist_item[domain_name]', with: 'new-item.test')
    page.evaluate_script("document.getElementById('wishlist_item_user_id').value = '#{other_user.id}'")

    click_link_or_button('Submit')
    assert(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  end

  def test_domain_name_must_be_a_valid_domain
    fill_in('wishlist_item[domain_name]', with: 'not a real domain')
    click_link_or_button('Submit')

    assert_not(page.has_css?('div.notice', text: 'Created successfully.'))
    assert(page.has_text?('Domain name is invalid'))
  end

  def test_must_not_exceed_total_list_capacity
    setting = settings(:wishlist_size)
    setting.update!(value: '1')

    fill_in('wishlist_item[domain_name]', with: 'new-item.test')
    click_link_or_button('Submit')

    assert_not(page.has_css?('div.notice', text: 'Created successfully.'))
    assert(page.has_text?('Wishlist has too many items'))
  end

  def test_user_can_add_price
    fill_in('wishlist_item[price]', with: '5.00')
    find('#wishlist_item_price').native.send_keys(:return)

    @wishlist_item.reload

    assert(@wishlist_item.cents, 500)
    assert_current_path(wishlist_items_path)
  end

  def test_user_cannot_add_price_when_banned
    Ban.create!(user: @user, domain_name: @wishlist_item.domain_name,
                valid_from: Time.zone.today - 1, valid_until: Time.zone.today + 2)

    fill_in('wishlist_item[price]', with: '5.00')
    find('#wishlist_item_price').native.send_keys(:return)

    @wishlist_item.reload

    assert(page.has_css?(
      'div.alert',
      text: "You are banned from participating in auctions for domain(s): #{@wishlist_item.domain_name}.")
    )
    assert_nil(@wishlist_item.cents)
    assert_current_path(wishlist_items_path)
  end

  def test_user_can_delete_price
    @wishlist_item.update!(cents: 10000)
    fill_in('wishlist_item[price]', with: '')
    find('#wishlist_item_price').native.send_keys(:return)

    @wishlist_item.reload

    assert_nil(@wishlist_item.cents)
    assert_current_path(wishlist_items_path)
  end
end
