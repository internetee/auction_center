require 'application_system_test_case'

class SessionsTest < ApplicationSystemTestCase
  def test_can_sign_in_with_password
    visit(users_path)

    within('nav.menu-user') do
      click_link_or_button('Sign in')
    end

    fill_in('user_email', with: 'user@auction.test')
    fill_in('user_password', with: 'password123')

    within('form') do
      click_link_or_button('Sign in')
    end

    assert_text('Signed in successfully')
  end

  def test_can_sign_out_via_button
    user = users(:participant)
    sign_in(user)

    visit(user_path(user.uuid))
    click_link('Sign out')
    assert_text('Signed out successfully.')
  end

  def test_user_can_see_a_link_to_their_profile
    user = users(:participant)
    sign_in(user)

    visit(users_path)
    assert(page.has_link?('Profile', href: user_path(user.uuid)))
  end

  def test_link_to_profile_is_invisible_for_anonymous_users
    visit(users_path)
    refute(page.has_link?('Profile'))
  end

  def test_session_expires_in_10_minutes
    user = users(:participant)
    travel_to Time.parse('2010-07-05 10:30 +0000')

    visit(users_path)
    within('nav.menu-user') do
      click_link_or_button('Sign in')
    end

    fill_in('user_email', with: 'user@auction.test')
    fill_in('user_password', with: 'password123')

    within('form') do
      click_link_or_button('Sign in')
    end

    assert_text('Signed in successfully')

    travel_to Time.parse('2010-07-05 10:41 +0000')

    visit(auctions_path)
    assert_text("Your session expired. Please sign in again to continue")

    travel_back
  end
end
