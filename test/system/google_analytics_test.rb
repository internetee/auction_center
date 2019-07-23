require 'application_system_test_case'

class GoogleAnalyticsTest < ApplicationSystemTestCase
  def test_layout_includes_script_tags_in_production
    mock = MiniTest::Mock.new
    mock.expect(:production?, true)
    mock.expect(:development?, false)
    mock.expect(:test?, true)
    mock.expect(:test?, true)
    mock.expect(:test?, true)

    Rails.stub(:env, mock) do
      visit auctions_path

      value_tag = page.find_by_id('google-tracking-id', visible: false)
      assert_equal('MY-GOOGLE-ID', value_tag['data-value'])

      assert(page.has_xpath?(
               '//script[@src="https://www.googletagmanager.com/gtag/js?id=MY-GOOGLE-ID"]',
               visible: false
             ))
    end
  end
end
