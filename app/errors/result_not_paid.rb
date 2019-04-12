module Errors
  class ResultNotPaid < StandardError
    attr_reader :result_id, :message

    def initialize(result_id = nil)
      @result_id = result_id
      @message = "Result with id #{result_id} not in 'payment_received' status"
      super(message)
    end
  end
end
