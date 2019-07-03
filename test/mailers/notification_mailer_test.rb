require 'test_helper'
require 'support/mock_summary_report'

class NotificationMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user = users(:administrator)
    @mock_summary = MockSummaryReport.new(Date.yesterday, Date.today)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_mail_gets_delivered
    NotificationMailer.daily_summary_email(@user, @mock_summary).deliver_now

    assert_not(ActionMailer::Base.deliveries.empty?)
    email = ActionMailer::Base.deliveries.last
    assert_equal(['administrator@auction.test'], email.to)
    assert_equal('Daily summary for 2010-07-04', email.subject)
  end
end
