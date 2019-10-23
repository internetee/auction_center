require 'application_system_test_case'

class CreateUserTest < ApplicationSystemTestCase
  def teardown
    super

    clear_email_deliveries
  end

  def test_can_create_a_foreign_user_and_get_an_confirmation_email
    visit new_user_path

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[mobile_phone]', with: '+48600100200')
    select_from_dropdown('Poland', from: 'user[country_code]')
    check_checkbox('user[accepts_terms_and_conditions]')

    fill_in('user[surname]', with: 'Last Name')
    click_link_or_button('Sign up')

    assert(page.has_css?('div.alert', text: 'You have to confirm your email address before continuing'))
    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['new-user@auction.test'], last_email.to)
  end

  def test_needs_to_accept_terms_and_conditions
    visit new_user_path

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[mobile_phone]', with: '+48600100200')
    select_from_dropdown('Poland', from: 'user[country_code]')
    fill_in('user[surname]', with: 'Last Name')
    click_link_or_button('Sign up')

    assert(page.has_text?('Terms and conditions must be accepted'))
  end

  def test_cannot_create_new_user_if_already_signed_in
    sign_in(users(:participant))
    visit new_user_path

    assert(page.has_css?('div.notice', text: 'You are already signed in'))
  end

  def test_form_has_terms_and_conditions_link
    visit new_user_path
    assert(page.has_link?('auction portal user agreement', href: Setting.terms_and_conditions_link))
  end

  def test_terms_and_conditions_link_can_also_be_relative
    setting = Setting.find_by(code: :terms_and_conditions_link)
    setting.update!(value: '/terms_and_conditions.pdf')
    visit new_user_path
    assert(page.has_link?('auction portal user agreement', href: '/terms_and_conditions.pdf'))
  end
end
