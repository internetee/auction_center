require 'expected_application_job'

class Job
  include ActiveModel::Model

  attr_reader :job_class

  def initialize(job_class)
    raise(Errors::ExpectedApplicationJob.new, job_class) unless job_class < ApplicationJob

    @job_class = job_class
  end

  def name
    job_class.to_s
  end

  delegate :needs_to_run?, to: :job_class, prefix: false
end
