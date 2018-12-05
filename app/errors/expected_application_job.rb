module Errors
  class ExpectedApplicationJob < StandardError
    attr_reader :job_class, :message

    def initialize(job_class = nil)
      @job_class = job_class.to_s
      @message = "Expected #{job_class} to be a descendant of ApplicationJob."
      super(message)
    end
  end
end
