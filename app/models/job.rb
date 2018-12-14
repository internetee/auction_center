class Job
  include ActiveModel::Model

  attr_reader :job_name

  def initialize(job_name)
    @job_name = job_name
  end

  def job_class
    job_name.constantize
  end

  delegate :needs_to_run?, to: :job_class, prefix: false
end
