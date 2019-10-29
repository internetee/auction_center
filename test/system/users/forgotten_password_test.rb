require 'application_system_test_case'

class ForgottenPasswordTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
  end

  def test_can_reset_password_by_email
    visit new_user_password_path
    new_password = 'new_password'

    fill_in('user[email]', with: @user.email)
    click_link_or_button 'Send me reset password instructions'
    last_email = ActionMailer::Base.deliveries.last

    # Match link from the email, for example:
    # <p><a href=\"https://auction.example.com/sessions/password/edit?reset_password_token=c3vwRxLdSKot7HzTnVVh\">
    match_token = last_email.body.match(/reset_password_token=((\w|-)+)/)
    assert(match_token)

    visit edit_user_password_path(reset_password_token: match_token[1])
    fill_in('user[password]', with: new_password)
    fill_in('user[password_confirmation]', with: new_password)
    click_link_or_button('Change my password')

    @user.reload
    assert(@user.valid_password?(new_password))
  end

  def test_password_reset_button_localized
    visit new_user_password_path
    assert(page.has_button?("Send me reset password instructions"))
    click_link('Eesti keeles')
    assert(page.has_button?("Saada parooli muutmise juhised"))
  end

  def test_password_reset_form_localized
    visit new_user_password_path
    new_password = 'new_password'

    fill_in('user[email]', with: @user.email)
    click_link_or_button 'Send me reset password instructions'
    last_email = ActionMailer::Base.deliveries.last

    # Match link from the email, for example:
    # <p><a href=\"https://auction.example.com/sessions/password/edit?reset_password_token=c3vwRxLdSKot7HzTnVVh\">
    match_token = last_email.body.match(/reset_password_token=((\w|-)+)/)
    visit edit_user_password_path(reset_password_token: match_token[1])

    assert(page.has_content?("New password"))
    assert(page.has_content?("8 characters minimum"))
    assert(page.has_content?("Confirm new password"))
    assert(page.has_button?("Change my password"))

    click_link('Eesti keeles')

    assert(page.has_content?("Uus parool"))
    assert(page.has_content?("Vähemalt 8 märki"))
    assert(page.has_content?("Sisesta uus parool uuesti"))
    assert(page.has_button?("Muuda mu parool"))
  end
end
