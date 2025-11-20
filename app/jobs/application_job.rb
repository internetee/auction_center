class ApplicationJob < ActiveJob::Base
  # Track job execution time and failures with Yabeda metrics
  around_perform do |job, block|
    labels = {
      job: job.class.name,
      queue: job.queue_name || "default"
    }

    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    block.call
  rescue => e
    Yabeda.jobs.job_failures_total.increment(labels.merge(exception_class: e.class.name))
    raise
  ensure
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    Yabeda.jobs.job_duration.measure(labels, duration)
  end

  rescue_from StandardError do |e|
    Rails.logger.info e
    Airbrake.notify(e)
  end
end
