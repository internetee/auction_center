require 'application_system_test_case'

class StatisticsTest < ApplicationSystemTestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone
    @administrator = users(:administrator)
    [StatisticsReport::Auction,
     StatisticsReport::Result,
     StatisticsReport::Invoice].each { |klass| klass.refresh }
  end

  def teardown
    super

    travel_back

    WebMock.reset!
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def test_statistic_page_has_all_tables
    sign_in(@administrator)

    visit admin_statistics_path
    assert(page.has_css?('#average-bids-chart'))
    assert(page.has_css?('#unregistered-monthly-chart'))
    assert(page.has_css?('#paid-domains-monthly-chart'))
    assert(page.has_css?('#unpaid-invoices-percentage-weekly-chart'))
    assert(page.has_css?('#domains-invoices-chart'))
    assert(page.has_css?('#users-chart'))
    assert(page.has_css?('#countries-chart'))
  end
end
