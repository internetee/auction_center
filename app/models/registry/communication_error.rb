module Registry
  class CommunicationError < StandardError
    attr_reader :request, :response_body, :response_code, :message

    def initialize(request, response_body, response_code)
      @request = request
      @response_body = response_body
      @response_code = response_code

      @message = <<~TEXT.squish
        Registry integration error. Request: #{request.uri}, body: #{request.body}
        Response: #{response_code}, body: #{response_body}
      TEXT

      super(message)
    end
  end
end
