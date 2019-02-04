class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |e|
    Airbrake.notify(e)
  end
end
