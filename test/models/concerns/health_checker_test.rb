require 'test_helper'

class HealthCheckerTest < ActiveSupport::TestCase
  EXAMPLE_URL = 'https://example.test'

  class DummyCheck < OkComputer::Check
    include HealthChecker
  end

  def test_simple_check_endpoint_marks_success_on_200
    checker = DummyCheck.new
    checker.stub(:default_get_request_response, { status: 200, body: {} }) do
      checker.simple_check_endpoint(url: EXAMPLE_URL, fail_message: 'down', success_message: 'up')
    end

    assert checker.success?
    assert_equal 'up', checker.message
  end

  def test_simple_check_endpoint_marks_failure_on_non_200
    checker = DummyCheck.new
    checker.stub(:default_get_request_response, { status: 500, body: {} }) do
      checker.simple_check_endpoint(url: EXAMPLE_URL, fail_message: 'down', success_message: 'up')
    end

    assert_not checker.success?
    assert_equal 'down', checker.message
  end

  def test_simple_check_endpoint_marks_failure_on_exception
    checker = DummyCheck.new
    checker.stub(:default_get_request_response, ->(*) { raise StandardError, 'boom' }) do
      checker.simple_check_endpoint(url: EXAMPLE_URL, fail_message: 'down', success_message: 'up')
    end

    assert_not checker.success?
    assert_equal 'down', checker.message
  end
end
