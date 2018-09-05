require 'application_system_test_case'

class EditAccountTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:user)
    sign_in(@user)
  end

  def test_update_of_email_requires_confirmation
    visit edit_user_path(@user)

    fill_in('user[email]', with: 'updated-email@auction.test')
    fill_in('user[current_password]', with: "password123")
    click_link_or_button('Update')
    assert(page.has_css?('div.alert', text: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'))

    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['updated-email@auction.test'], last_email.to)
  end

  def test_update_of_email_requires_providing_existing_password
    visit edit_user_path(@user)

    fill_in('user[email]', with: 'updated-email@auction.test')
    fill_in('user[current_password]', with: 'not-correct-password')
    click_link_or_button('Update')
    assert(page.has_css?('div.alert', text: 'Incorrect current password'))
    assert(ActionMailer::Base.deliveries.empty?)
  end

  def test_email_must_be_valid
    visit edit_user_path(@user)
  end
end
