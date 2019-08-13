require 'application_system_test_case'

class GoogleAnalyticsTest < ActionDispatch::IntegrationTest
  def test_layout_includes_script_tags_in_production
    mock = MiniTest::Mock.new
    mock.expect(:production?, true)
    mock.expect(:development?, false)
    mock.expect(:test?, true)
    mock.expect(:test?, true)
    mock.expect(:test?, true)

    Rails.stub(:env, mock) do
      get auctions_path

      assert_select '#google-tracking-id[data-value="MY-GOOGLE-ID"]'
      assert_select 'script[src="https://www.googletagmanager.com/gtag/js?id=MY-GOOGLE-ID"]'
    end
  end
end
