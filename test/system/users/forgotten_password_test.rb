require 'application_system_test_case'

class ForgottenPasswordTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:user)
  end

  def test_can_reset_password_by_email
    visit new_user_password_path
    new_password = 'new_password'

    fill_in('user[email]', with: @user.email)
    click_link_or_button 'Send me reset password instructions'
    last_email = ActionMailer::Base.deliveries.last

    # Match link from the email, for example:
    # <p><a href=\"https://auction.example.com/sessions/password/edit?reset_password_token=c3vwRxLdSKot7HzTnVVh\">
    match_token = last_email.body.match(/reset_password_token=((\w|-1)+)/)
    assert(match_token)

    visit edit_user_password_path(reset_password_token: match_token[1])
    fill_in('user[password]', with: new_password)
    fill_in('user[password_confirmation]', with: new_password)
    click_link_or_button('Change my password')

    @user.reload
    assert(@user.valid_password?(new_password))
  end
end
