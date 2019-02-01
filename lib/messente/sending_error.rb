module Messente
  class SendingError < StandardError
    attr_reader :code, :response_body, :message

    def initialize(code, body)
      @code = code
      @body = body
      @message = "Sending a message failed. Code: #{code}. Body: #{body}"
      super(message)
    end
  end
end
