require 'test_helper'

class SummaryTest < ActiveSupport::TestCase
  def test_holds_start_and_end_date
    yesterday = Date.yesterday
    today = Date.today
    summary = Summary.new(yesterday, today)

    assert_equal(yesterday, summary.start_date)
    assert_equal(today, summary.end_date)
  end
end
