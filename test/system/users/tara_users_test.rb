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
        'name' => @user.uid,
      },
    }

    @new_user_hash = {
      'provider' => 'tara',
      'uid' => 'EE51007050604',
      'info' => {
        'first_name' => 'User',
        'last_name' => 'OmniAuth',
        'name' => 'EE51007050604',
      },
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
    check_checkbox('user[accepts_terms_and_conditions]')
    assert(page.has_link?('auction portal user agreement', href: Setting.find_by(code: 'terms_and_conditions_link').retrieve))

    click_link_or_button('Sign up')
    assert(page.has_css?('div.alert', text: 'You need to confirm your email address to activate the account. We sent you an email with the activation link!'))
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

  def test_banned_user_can_see_the_ban_notification_for_one_domain
    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone
    valid_auction_with_no_offers = auctions(:valid_without_offers)
    Ban.create!(user: @user,
                domain_name: valid_auction_with_no_offers.domain_name,
                valid_from: Time.zone.today - 1, valid_until: Time.zone.today + 2)

    test_existing_user_gets_signed_in

    text = <<~TEXT.squish
      You are banned from participating in auctions for domain(s): no-offers.test.
    TEXT

    visit auctions_path
    assert(page.has_css?('div.ban', text: text))

    travel_back
  end

  def test_banned_user_can_see_the_ban_notification_for_many_domains
    setting = settings(:ban_number_of_strikes)
    setting.update!(value: '1')
    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone
    Ban.create!(user: @user,
                valid_from: Time.zone.today - 1, valid_until: Time.zone.today + 2)

    test_existing_user_gets_signed_in

    text = <<~TEXT.squish
      You are banned from participating in .ee domain auctions due to multiple overdue
      invoices until 2010-07-07.
    TEXT

    visit auctions_path
    assert(page.has_css?('div.ban', text: text))

    travel_back
  end

  def test_tampering_raises_an_error
    OmniAuth.config.mock_auth[:tara] = OmniAuth::AuthHash.new(@new_user_hash)

    visit root_path
    click_link('Sign in')

    within('#tara-sign-in') do
      click_link('Sign in')
    end

    fill_in('user[email]', with: 'new-user@auction.test')
    page.evaluate_script("document.getElementById('user_given_names').value = 'FOO'")
    check_checkbox('user[accepts_terms_and_conditions]')

    click_link_or_button('Sign up')
    assert(page.has_css?('div.alert', text: 'Tampering detected. Sign in cancelled.'))
  end

  def test_existing_user_can_change_their_email
    sign_in(@user)

    visit edit_user_path(@user.uuid)
    fill_in('user[email]', with: 'new-user@auction.test')
    click_link_or_button('Update')

    assert_text 'Confirmation link was sent to new email address. Please confirm the address for the change to take an effect!'
  end

  def test_existing_user_can_create_password
    sign_in(@user)

    visit edit_user_path(@user.uuid)
    password = 'password123'
    fill_in('user[password]', with: password)
    fill_in('user[password_confirmation]', with: password)
    click_link_or_button('Update')

    assert(new_user_session_path, page.current_path)

    fill_in('user[email]', with: @user.email)
    fill_in('user[password]', with: password)

    within('#password-sign-in') do
      click_link_or_button('Sign in')
    end

    assert(page.has_css?('div.notice', text: 'Signed in successfully.'))
  end
end
