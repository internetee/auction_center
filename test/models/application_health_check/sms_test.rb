require 'test_helper'

class SMSTest < ActiveSupport::TestCase
  def stub_sms_setting
    setting_double = Object.new
    setting_double.define_singleton_method(:retrieve) { 'https://example.test/sms' }
    Setting.stub(:find_by, setting_double) { yield }
  end

  def test_check_marks_success_when_endpoint_returns_ok
    stub_sms_setting do
      checker = ApplicationHealthCheck::Sms.new
      checker.stub(:default_get_request_response, { status: 200, body: {} }) do
        checker.check
      end

      assert checker.success?
      assert_equal 'SMS API is OK', checker.message
    end
  end

  def test_check_marks_failure_when_endpoint_returns_error
    stub_sms_setting do
      checker = ApplicationHealthCheck::Sms.new
      checker.stub(:default_get_request_response, { status: 503, body: {} }) do
        checker.check
      end

      assert_not checker.success?
      assert_equal 'SMS API is down', checker.message
    end
  end
end
