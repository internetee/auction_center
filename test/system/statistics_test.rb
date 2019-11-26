require 'application_system_test_case'

class StatisticsTest < ApplicationSystemTestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone
    @administrator = users(:administrator)
  end

  def teardown
    super

    travel_back
  end

  def test_statistic_page_has_all_tables
    sign_in(@administrator)

    visit admin_statistics_path
    assert(page.has_css?('#average-bids-chart'))
    assert(page.has_css?('#unregistered-domains-chart'))
    assert(page.has_css?('#paid-domains-monthly-chart'))
    assert(page.has_css?('#unpaid-invoices-percentage-chart'))
    assert(page.has_css?('#domains-invoices-chart'))
    assert(page.has_css?('#users-chart'))
    assert(page.has_css?('#countries-chart'))
  end
end
