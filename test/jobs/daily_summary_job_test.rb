require 'test_helper'

class DailySummaryJobTest < ActiveJob::TestCase
  def setup
    super

    @administrator = users(:administrator)
    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
    clear_email_deliveries
  end

  def test_sends_email_to_administrator
    perform_enqueued_jobs do
      DailySummaryJob.perform_now
    end

    refute(ActionMailer::Base.deliveries.empty?)
    email = ActionMailer::Base.deliveries.last
    assert_equal(['administrator@auction.test'], email.to)
    assert_equal('Daily summary for 2010-07-04', email.subject)
  end
end
