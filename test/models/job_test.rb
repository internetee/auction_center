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

  def test_namespaced_job_is_allowed
    job = Job.new('Recommendation::ClassifyUnclassifiedDomainsJob')

    assert job.valid?
    assert_equal Recommendation::ClassifyUnclassifiedDomainsJob, job.job_class
  end

  def test_embed_job_is_allowed
    job = Job.new('Recommendation::EmbedUnembeddedDomainsJob')

    assert job.valid?
    assert_equal Recommendation::EmbedUnembeddedDomainsJob, job.job_class
  end
end
