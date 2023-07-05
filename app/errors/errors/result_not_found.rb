module Errors
  class ResultNotFound < StandardError
    attr_reader :result_id, :message

    def initialize(result_id = nil)
      @result_id = result_id
      @message = "Result with id #{result_id} does not exist"
      super(message)
    end
  end
end
