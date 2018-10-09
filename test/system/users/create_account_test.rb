require 'application_system_test_case'

class CreateAccountTest < ApplicationSystemTestCase
  def test_can_create_a_foreign_user_and_get_an_confirmation_email
    visit new_user_path

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[identity_code]', with: '81060885963')
    fill_in('user[mobile_phone]', with: '+48600100200')
    select('Poland', from: 'user[country_code]')
    fill_in('user[surname]', with: 'Last Name')
    click_link_or_button('Sign up')

    assert(page.has_css?('div.alert', text: 'You have to confirm your email address before continuing'))
    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['new-user@auction.test'], last_email.to)
  end

  def test_cannot_create_new_user_if_already_signed_in
    sign_in(users(:user))
    visit new_user_path

    assert(page.has_css?('div.alert', text: 'You are already signed in'))
  end

  def test_certain_fields_are_required
    visit new_user_path
    click_link_or_button('Sign up')

    errors_list = page.find('#errors').all('li')
    assert_equal(5, errors_list.size)
    errors_array = errors_list.collect { |i| i.text }

    expected_errors = ["Email can't be blank", "Password can't be blank",
                       "Identity code can't be blank", "Mobile phone can't be blank",
                       "Identity code is invalid"]

    assert_equal(errors_array.to_set, expected_errors.to_set)
  end

  def test_can_create_an_estonian_user_via_id_card
    skip('Not implemented yet')
  end

  def test_can_create_an_estonian_user_via_mobile_id
    skip('Not implemented yet')
  end
end
