require 'application_system_test_case'

class AdminUsersEditTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:user)
    @administrator = users(:administrator)

    sign_in(@administrator)
  end

  def test_can_update_user_role
    visit edit_admin_user_path(@user)

    check('user_roles_administrator')
    uncheck('user_roles_participant')
    click_link_or_button('Update')
  end
end
