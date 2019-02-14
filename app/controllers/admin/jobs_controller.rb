module Admin
  class JobsController < BaseController
    before_action :authorize_user

    def index
      set_jobs
    end

    def create
      job_class = set_job_class
      respond_to do |format|
        if job_class.perform_later
          format.html { redirect_to admin_jobs_path, notice: t('.enqueued') }
          format.json { render json: { job_name: job_name, enqueued: true }, status: :created }
        else
          format.html { redirect_to admin_jobs_path, notice: t(:error) }
          format.json do
            render json: { job_name: job_name, enqueued: false }, status: :unprocessable_entity
          end
        end
      end
    end

    private

    def set_job_class
      job_name = params.require(:job).require(:job_class)
      Job.new(job_name).job_class
    end

    def set_jobs
      @jobs = [Job.new('ResultCreationJob'), Job.new('InvoiceCancellationJob'),
               Job.new('InvoiceCreationJob'), Job.new('AuctionCreationJob'),
               Job.new('DomainRegistrationCheckJob'), Job.new('ResultStatusUpdateJob')]
    end

    def authorize_user
      authorize! :read, Job
      authorize! :create, Job
    end
  end
end
