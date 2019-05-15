require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  def setup
    super

    @user = users(:administrator)
    @time = Time.parse('2010-07-05 10:30 +0000')

    travel_to @time
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_mail_gets_delivered
    NotificationMailer.daily_summary_email(@user).deliver_now

    refute(ActionMailer::Base.deliveries.empty?)
    email = ActionMailer::Base.deliveries.last
    assert_equal(['administrator@auction.test'], email.to)
    assert_equal('Daily summary for 2010-07-04', email.subject)
  end
end
