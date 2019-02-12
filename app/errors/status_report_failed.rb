module Errors
  class StatusReportFailed < StandardError
    attr_reader :result_id, :response_body, :response_code, :message

    def initialize(result_id, response_body, response_code)
      @result_id = result_id
      @response_body = response_body
      @response_code = response_code

      @message = <<~TEXT.squish
         Registry response failure for Result #{result_id}.
         Response code: #{response_code}, body: #{response_body}
      TEXT

      super(message)
    end
  end
end
