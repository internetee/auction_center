require 'test_helper'

class RegistryTest < ActiveSupport::TestCase
  def test_check_reports_failure_when_integration_disabled
    Feature.stub(:registry_integration_enabled?, false) do
      checker = ApplicationHealthCheck::Registry.new
      checker.check

      assert_not checker.success?
      assert_equal 'Registry integration disabled', checker.message
    end
  end

  def test_check_marks_success_when_endpoint_returns_ok
    Feature.stub(:registry_integration_enabled?, true) do
      checker = ApplicationHealthCheck::Registry.new
      checker.stub(:default_get_request_response, { status: 200, body: {} }) do
        checker.check
      end

      assert checker.success?
      assert_equal 'Registry integration is up and running', checker.message
    end
  end

  def test_check_marks_failure_when_endpoint_returns_error
    checker = ApplicationHealthCheck::Registry.new
    Feature.stub(:registry_integration_enabled?, true) do
      checker.stub(:default_get_request_response, { status: 503, body: {} }) do
        checker.check
      end
    end

    assert(checker.message.present?)
    assert_not checker.success?
  end
end
