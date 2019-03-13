require 'test_helper'

class DomainRegistrationMailerTest < ActionMailer::TestCase
  def setup
    super

    @result = results(:with_invoice)
    @time = Time.parse('2010-07-05 10:30 +0000')

    travel_to @time
  end

  def teardown
    super

    travel_back
  end

  def test_result_is_updated_after_registration_reminder
    DomainRegistrationMailer.registration_reminder_email(@result).deliver_now

    @result.reload

    assert_equal(@time, @result.registration_reminder_sent_at)
  end
end
