require 'test_helper'

class JobTest < ActiveSupport::TestCase
  def setup
    super

    @job_class = InvoiceCreationJob
    @instance = Job.new(@job_class)
  end

  def test_instance_methods_correspond_with_the_class
    assert_equal('InvoiceCreationJob', @instance.name)
    assert_equal(true, @instance.needs_to_run?)
  end

  def test_raises_error_when_unexpected_class_is_given
    assert_raises(Errors::ExpectedApplicationJob) do
      Job.new(Result)
    end
  end
end
