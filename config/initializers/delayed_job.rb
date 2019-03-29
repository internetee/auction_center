Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 5
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Rails.logger
