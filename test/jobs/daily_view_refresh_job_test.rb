require 'test_helper'

class DailyViewRefreshJobTest < ActiveJob::TestCase

  def test_job_generates_invoice_for_results_that_need_them
    perform_enqueued_jobs do
      DailyViewRefreshJob.perform_now
      assert_equal(StatisticsReport::Auction.all.count, Auction.all.count)
      assert_equal(StatisticsReport::Invoice.all.count, Invoice.all.count)
      assert_equal(StatisticsReport::Result.all.count, Result.all.count)
    end
  end
end
