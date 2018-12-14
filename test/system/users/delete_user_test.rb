require 'application_system_test_case'

class DeleteUserTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
    sign_in(@user)
  end

  def teardown
    super

    clear_email_deliveries
  end

  def test_a_user_can_delete_their_own_account
    visit user_path(@user)

    assert(page.has_link?('Delete account'))

    accept_confirm do
      click_link_or_button('Delete account')
    end

    assert_text('You have been logged out and your account has been deleted.')
  end
end
