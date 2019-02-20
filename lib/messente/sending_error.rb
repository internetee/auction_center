module Messente
  class SendingError < StandardError
    attr_reader :response_code
    attr_reader :response_body
    attr_reader :message
    attr_reader :request_body

    def initialize(response_code, response_body, request_body)
      @response_code = response_code
      @response_body = response_body
      @request_body = request_body
      @message = <<~TEXT.squish
        Sending a message failed.
        Request: #{request_body}.
        Response code: #{response_code}. Body: #{response_body}"
      TEXT

      super(message)
    end
  end
end
