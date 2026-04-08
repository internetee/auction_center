require 'test_helper'

class LocalesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
  end

  def test_update_sets_locale_cookie_when_not_signed_in
    cookies.delete(:locale)

    patch '/locale', params: { locale: 'et' }, headers: { 'HTTP_REFERER' => '/' }

    assert_response :redirect
    assert_equal 'et', cookies[:locale]
  end

  def test_update_updates_user_locale_when_signed_in
    sign_in @user

    patch '/locale', params: { locale: 'et' }, headers: { 'HTTP_REFERER' => '/' }

    assert_response :redirect
    assert_equal 'et', @user.reload.locale
  end
end
