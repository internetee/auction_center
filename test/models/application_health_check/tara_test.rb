require 'test_helper'

class TaraTest < ActiveSupport::TestCase

  def stub_tara_setting
    setting_double = Object.new
    setting_double.define_singleton_method(:retrieve) { 'https://example.test/tara' }
    Setting.stub(:find_by, setting_double) { yield }
  end

  def test_check_marks_success_when_endpoint_returns_ok
    stub_tara_setting do
      checker = ApplicationHealthCheck::Tara.new
      checker.stub(:default_get_request_response, { status: 200, body: {} }) do
        checker.check
      end

      assert checker.success?
      assert_equal 'Tara API is OK and running', checker.message
    end
  end

  def test_check_marks_failure_when_endpoint_returns_error
    stub_tara_setting do
      checker = ApplicationHealthCheck::Tara.new
      checker.stub(:default_get_request_response, { status: 503, body: {} }) do
        checker.check
      end

      assert_not checker.success?
      assert_equal 'Tara API is down', checker.message
    end
  end
end
