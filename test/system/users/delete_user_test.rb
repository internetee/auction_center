require 'application_system_test_case'

class DeleteUserTest < ApplicationSystemTestCase

  def teardown
    super

    clear_email_deliveries
  end

  def test_a_user_cannot_delete_their_own_account_if_invoice_issued
    @user = users(:participant)
    sign_in(@user)
    visit user_path(@user.uuid)

    assert(page.has_link?('Delete account'))

    accept_confirm do
      click_link_or_button('Delete account')
    end

    assert_text('Your account cannot be deleted because you got unpaid invoices.')
  end

  def test_a_user_can_delete_their_own_account_if_no_invoice_issued
    @user = users(:second_place_participant)
    sign_in(@user)
    visit user_path(@user.uuid)

    assert(page.has_link?('Delete account'))

    accept_confirm do
      click_link_or_button('Delete account')
    end

    assert_text('You have been logged out and your account has been deleted.')
  end
end
