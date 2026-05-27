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
    job = Job.new('Recommendation::ClassifyAuctionDomainsJob')

    assert job.valid?
    assert_equal Recommendation::ClassifyAuctionDomainsJob, job.job_class
  end

  def test_refresh_scores_job_is_allowed
    job = Job.new('Recommendation::RefreshUserAuctionScoresJob')

    assert job.valid?
    assert_equal Recommendation::RefreshUserAuctionScoresJob, job.job_class
  end
end
