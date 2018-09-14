require 'application_system_test_case'

class SessionsTest < ApplicationSystemTestCase
  def setup
    super
  end

  def test_can_sign_in_with_password
    visit(users_path)

    within('nav') do
      click_link_or_button('Sign in')
    end

    fill_in('user_email', with: 'user@auction.test')
    fill_in('user_password', with: 'password123')

    within('form') do
      click_link_or_button('Sign in')
    end

    assert_text('Welcome back, Joe John User')
  end

  def test_can_sign_out_via_button
    user = users(:user)
    sign_in(user)

    visit(user_path(user))
    click_link('Sign out')
    assert_text('Signed out successfully.')
  end
end
