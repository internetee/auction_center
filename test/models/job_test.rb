require 'test_helper'

class JobTest < ActiveSupport::TestCase
  def setup
    super

    @job_name = 'InvoiceCreationJob'
    @instance = Job.new(@job_name)
  end

  def test_instance_methods_correspond_with_the_class
    assert_equal(InvoiceCreationJob, @instance.job_class)
    assert_equal(true, @instance.needs_to_run?)
  end
end
