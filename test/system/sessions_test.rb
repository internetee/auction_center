require 'application_system_test_case'

class SessionsTest < ApplicationSystemTestCase
  test "visit login page" do
    visit new_user_session_path
    assert_selector "h2", text: I18n.t('devise.sessions.new.sign_in_with_identity_document')
    assert_selector "h2", text: I18n.t('devise.sessions.new.sign_in_with_password')
  end

  test "login with email and password" do
    visit new_user_session_path
  
    within('div.o-card:nth-of-type(2)') do
      fill_in I18n.t('users.email'), with: users(:participant).email
      fill_in I18n.t('users.password'), with: "secret"
  
      click_on I18n.t(:sign_in)
    end

    assert_current_path new_user_session_path
  end

  test "links for password recovery and account confirmation are present" do
    visit new_user_session_path

    assert_selector "a", text: I18n.t('devise.shared.links.forgot_your_password')
    assert_selector "a", text: I18n.t('devise.shared.links.didnt_receive_confirmation_instructions')
  end

  # def setup
  #   super
  #   @original_wait_time = Capybara.default_max_wait_time
  #   Capybara.default_max_wait_time = 10
  # end

  # def teardown
  #   super

  #   Capybara.default_max_wait_time = @original_wait_time
  # end

  # def test_can_sign_in_with_password
  #   visit(users_path)

  #   within('nav.menu-user') do
  #     click_link_or_button('Sign in')
  #   end

  #   fill_in('user_email', with: 'user@auction.test')
  #   fill_in('user_password', with: 'password123')

  #   within('form#new_user') do
  #     click_link_or_button('Sign in')
  #   end

  #   assert_text('Signed in successfully')
  #   refute_text('You are banned from participating in auctions for domain(s)')
  # end

  # def test_can_sign_out_via_button
  #   user = users(:participant)
  #   sign_in(user)

  #   visit(user_path(user.uuid))
  #   click_link('Sign out')
  #   assert_text('Signed out successfully.')
  # end

  # def test_user_can_see_a_link_to_their_profile
  #   user = users(:participant)
  #   sign_in(user)

  #   visit(users_path)
  #   assert(page.has_link?('Profile', href: user_path(user.uuid)))
  # end

  # def test_link_to_profile_is_invisible_for_anonymous_users
  #   visit(users_path)
  #   assert_not(page.has_link?('Profile'))
  # end

  # def test_session_expires_in_10_minutes
  #   travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone

  #   visit(users_path)
  #   within('nav.menu-user') do
  #     click_link_or_button('Sign in')
  #   end

  #   fill_in('user_email', with: 'user@auction.test')
  #   fill_in('user_password', with: 'password123')

  #   within('form#new_user') do
  #     click_link_or_button('Sign in')
  #   end

  #   assert_text('Signed in successfully')

  #   travel_to Time.parse('2010-07-05 10:41 +0000').in_time_zone

  #   visit(auctions_path)
  #   assert_text('Your session expired. Please sign in again to continue')

  #   travel_back
  # end
end
