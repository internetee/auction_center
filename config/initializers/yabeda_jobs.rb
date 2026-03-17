# frozen_string_literal: true

# Yabeda metrics for background jobs (Delayed Job)
# Tracks job duration and failures

Yabeda.configure do
  group :jobs do
    histogram :job_duration,
      comment: "Background job execution time",
      unit: :seconds,
      tags: %i[job queue],
      buckets: [0.1, 0.5, 1, 5, 10, 30]

    counter :job_failures_total,
      comment: "Total failed background jobs",
      tags: %i[job queue exception_class]
  end
end
