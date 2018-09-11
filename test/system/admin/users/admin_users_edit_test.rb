require 'application_system_test_case'

class AdminUsersEditTest < ApplicationSystemTestCase
  def setup
    super
    @user = users(:user)
    @administrator = users(:administrator)

    sign_in(@administrator)
  end

  def test_administrator_can_update_users_role
    visit edit_admin_user_path(@user)

    check('user_roles_administrator')
    uncheck('user_roles_participant')
    click_link_or_button('Update')
  end

  def test_administrator_can_update_users_phone_number
    visit edit_admin_user_path(@user)

    fill_in('user[mobile_phone]', with: '+37255000003')
    click_link_or_button('Update')
    assert_text('+37255000003')
  end

  def test_administrator_can_delete_user
    visit admin_user_path(@user)

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert_text('Deleted successfully.')
  end
end
