require 'test_helper'

class InternalCheckTest < ActiveSupport::TestCase

  def test_check_list
    asserted_checks = %w[default database api email registry sms tara]
    assert_equal(asserted_checks, ApplicationHealthCheck::InternalCheck::CHECK_NAMES)
  end

  def test_returns_hash
    result = ApplicationHealthCheck::InternalCheck.new.run
    assert(result.is_a?(Hash))
  end

  def test_has_run_method
    mock = Minitest::Mock.new
    ApplicationHealthCheck::InternalCheck.stub(:new, mock) do
      mock.expect(:run, {})
    end
  end
end
