require 'application_system_test_case'

class GoogleAnalyticsIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    patch cookies_path, params: { cookies: 'accepted', analytics_selected: '1' }
  end

  def test_google_analytics_integration
    tracking_id = 'test-tracking-id'
    Rails.configuration.customization[:google_analytics][:tracking_id] = tracking_id

    get auctions_path

    # assert_select %Q(#google-tracking-id[data-value="#{tracking_id}"])
    assert_select %Q(script[src="https://www.googletagmanager.com/gtag/js?id=#{tracking_id}"])
  end
end
