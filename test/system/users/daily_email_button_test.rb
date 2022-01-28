require 'application_system_test_case'

class DailyEmailButtonTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
  end

  def teardown
    super

    WebMock.reset!
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def test_button_not_marked_without_login
    visit auctions_path

    assert_not(page.has_css?('.green.check.icon'))
  end

  def test_button_marked_if_subscribed_login
    @user.update(daily_summary: true)
    sign_in(@user)
    visit auctions_path

    assert(page.has_css?('.green.check.icon'))
  end

  def test_button_not_marked_if_unsubscribed_login
    @user.update(daily_summary: false)
    sign_in(@user)
    visit auctions_path

    assert_not(page.has_css?('.green.check.icon'))
  end
end
