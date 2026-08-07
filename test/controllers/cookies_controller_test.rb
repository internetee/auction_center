require 'test_helper'

class CookiesControllerTest < ActionController::TestCase
  tests CookiesController
  include Devise::Test::ControllerHelpers

  def setup
    super
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw do
      patch '/cookies', to: 'cookies#update'
    end
  end

  def assert_cookie_update(cookies_value:, analytics_value:, analytics_selected: '1')
    patch :update, params: { cookies: cookies_value, analytics_selected: analytics_selected }

    assert_redirected_to '/'
    assert_equal 'accepted', cookies[:cookie_dialog]
    assert_equal analytics_value, cookies[:google_analytics]
  end

  def test_update_accepts_analytics_when_all_cookies_accepted
    assert_cookie_update(cookies_value: 'accepted', analytics_value: 'accepted', analytics_selected: '0')
  end

  def test_update_declines_analytics_when_not_selected
    assert_cookie_update(cookies_value: 'declined', analytics_value: 'declined', analytics_selected: '0')
  end

  def test_update_accepts_analytics_when_only_analytics_selected
    assert_cookie_update(cookies_value: 'declined', analytics_value: 'accepted', analytics_selected: '1')
  end

  def test_update_declines_analytics_by_default
    assert_cookie_update(cookies_value: nil, analytics_value: 'declined', analytics_selected: '0')
  end
end
