require 'tampering_detected'

module Admin
  class JobsController < BaseController
    before_action :authorize_user

    rescue_from Errors::TamperingDetected do |e|
      redirect_to root_url, alert: t('admin.jobs.create.tampering')
      Airbrake.notify(e)
    end

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
      job = Job.new(job_name)

      if job.valid?
        job.job_class
      else
        raise Errors::TamperingDetected
      end
    end

    def set_jobs
      @jobs = Job::ALLOWED_JOB_NAMES.map do |name|
        Job.new(name)
      end
    end

    def authorize_user
      authorize! :read, Job
      authorize! :create, Job
    end
  end
end
