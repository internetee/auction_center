module Errors
  class ResultNotSold < StandardError
    attr_reader :result_id, :message

    def initialize(result_id = nil)
      @result_id = result_id
      @message = "Result with id #{result_id} is not sold"
      super(message)
    end
  end
end
