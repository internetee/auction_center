module Concerns
  module HealthChecker
    extend ActiveSupport::Concern
    include Concerns::HttpRequester

    def report_failure(message)
      mark_failure
      mark_message message
    end

    def headers
      { 'Content-Type': 'application/json' }
    end

    def simple_check_endpoint(url:, no_url_message:, fail_message:, success_message:)
      if url
        url = URI(url)
        result = default_get_request_response(url: url, headers: headers)
        status = Net::HTTPResponse::CODE_TO_OBJ[result[:status].to_s]

        status == Net::HTTPOK ? mark_message(success_message) : report_failure(fail_message)
      else
        report_failure(no_url_message)
      end
    end
  end
end
