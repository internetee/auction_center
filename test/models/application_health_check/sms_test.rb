require 'test_helper'

class SMSTest < ActiveSupport::TestCase
  def test_check
    checker = ApplicationHealthCheck::Sms.new
    checker.check

    assert(checker.message.present?)
  end

  def test_returns_error_on_timeout
    setting = settings(:check_sms_url)
    setting.update!(value: 'http://example.com:61')
    checker = ApplicationHealthCheck::Sms.new
    checker.check
    assert_not(checker.success?)
  end
end
