class Job
  ALLOWED_JOB_NAMES = %w[ResultCreationJob InvoiceCancellationJob InvoiceCreationJob
                         AuctionCreationJob DomainRegistrationCheckJob ResultStatusUpdateJob
                         DomainRegistrationReminderJob].freeze

  include ActiveModel::Model

  attr_reader :job_name

  validates :job_name, inclusion: { in: ALLOWED_JOB_NAMES }

  def initialize(job_name)
    @job_name = job_name
  end

  def job_class
    job_name.constantize
  end

  delegate :needs_to_run?, to: :job_class, prefix: false
end
