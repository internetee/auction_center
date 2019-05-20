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

  def test_domain_name_must_be_a_valid_domain
    fill_in('wishlist_item[domain_name]', with: 'not a real domain')
    click_link_or_button('Submit')

    refute(page.has_css?('div.notice', text: 'Created successfully.'))
    assert(page.has_text?('Domain name is invalid'))
  end

  def test_must_not_exceed_total_list_capacity
    setting = settings(:wishlist_size)
    setting.update!(value: '1')

    fill_in('wishlist_item[domain_name]', with: 'new-item.test')
    click_link_or_button('Submit')

    refute(page.has_css?('div.notice', text: 'Created successfully.'))
    assert(page.has_text?('Wishlist has too many items'))
  end
end
