# encoding: utf-8
require 'application_system_test_case'

class TaraUsersTest < ApplicationSystemTestCase
  def setup
    super

    OmniAuth.config.test_mode = true
    @user = users(:signed_in_with_omniauth)

    @existing_user_hash = {
      'provider' => @user.provider,
      'uid' => @user.uid,
      'info' => {
        'first_name' => @user.given_names,
        'last_name' => @user.surname,
        'name' => @user.uid
      }
    }

    @new_user_hash = {
      'provider' => 'tara',
      'uid' => 'EE51007050604',
      'info' => {
        'first_name' => 'User',
        'last_name' => 'OmniAuth',
        'name' => 'EE51007050604',
      }
    }
  end

  def teardown
    super

    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth['tara'] = nil
    clear_email_deliveries
  end

  def test_user_can_create_new_account_with_tara
    OmniAuth.config.mock_auth[:tara] = OmniAuth::AuthHash.new(@new_user_hash)

    visit root_path
    click_link('Sign in')

    within('#tara-sign-in') do
      click_link('Sign in')
    end

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    check_checkbox('user[accepts_terms_and_conditions]')

    click_link_or_button('Sign up')
    assert(page.has_css?('div.alert', text: 'You have to confirm your email address before continuing'))
    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['new-user@auction.test'], last_email.to)
  end

  def test_user_needs_to_fill_in_email_and_accept_terms_and_conditions
    OmniAuth.config.mock_auth[:tara] = OmniAuth::AuthHash.new(@new_user_hash)

    visit root_path
    click_link('Sign in')

    within('#tara-sign-in') do
      click_link('Sign in')
    end

    fill_in('user[password]', with: 'pass word')
    fill_in('user[password_confirmation]', with: 'password')

    click_link_or_button('Sign up')

    assert(page.has_text?('Terms and conditions must be accepted'))
    assert(page.has_text?("Email can't be blank"))
  end

  def test_existing_user_gets_signed_in
    OmniAuth.config.mock_auth[:tara] = OmniAuth::AuthHash.new(@existing_user_hash)

    visit root_path
    click_link('Sign in')

    within('#tara-sign-in') do
      click_link('Sign in')
    end

    assert_text('Signed in successfully')
  end

  def test_tampering_raises_an_error
    OmniAuth.config.mock_auth[:tara] = OmniAuth::AuthHash.new(@new_user_hash)

    visit root_path
    click_link('Sign in')

    within('#tara-sign-in') do
      click_link('Sign in')
    end

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    page.evaluate_script("document.getElementById('user_given_names').value = 'FOO'")
    check_checkbox('user[accepts_terms_and_conditions]')

    click_link_or_button('Sign up')
    assert(page.has_css?('div.alert', text: 'Tampering detected. Sign in cancelled.'))
  end

  def test_existing_user_can_change_their_email
    sign_in(@user)

    visit edit_user_path(@user.uuid)
    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Submit')

    assert(page.has_css?('div.notice', text: 'Updated successfully.'))
  end
end
