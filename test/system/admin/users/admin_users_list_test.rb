require 'application_system_test_case'

class AdminUsersListTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:administrator)
    sign_in(@user)
  end

  def test_users_are_ordered_by_descending_created_at_date
    visit admin_users_path

    display_name_cells = page.find('#users-table-body').find_all('th')
    # First is users(:user)
    assert_equal('Joe John User', display_name_cells[0].text)

    # Second is users(:administrator) (self)
    assert_equal('John Joe Administrator', display_name_cells[1].text)
  end

  def test_user_display_names_are_links
    edited_user = users(:user)

    visit admin_users_path
    display_name_cell_link = page.find('a', text: 'Joe John User')
    display_name_cell_link.click

    assert_current_path(admin_user_path(edited_user))
  end
end
