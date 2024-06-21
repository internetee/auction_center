class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |e|
    Rails.logger.info e
    Airbrake.notify(e)
  end
end
