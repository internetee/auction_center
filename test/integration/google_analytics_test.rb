require 'application_system_test_case'

class GoogleAnalyticsTest < ActionDispatch::IntegrationTest
  def test_google_analytics_integration
    get auctions_path

    assert_select '#google-tracking-id[data-value="MY-GOOGLE-ID"]'
    assert_select 'script[src="https://www.googletagmanager.com/gtag/js?id=MY-GOOGLE-ID"]'
  end
end
