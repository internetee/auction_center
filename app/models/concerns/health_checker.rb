
module HealthChecker
  extend ActiveSupport::Concern
  include HttpRequester

  def report_failure(message)
    mark_failure
    mark_message message
  end

  def headers
    { 'Content-Type': 'application/json' }
  end

  # rubocop:disable Style/RescueStandardError
  def simple_check_endpoint(url:, fail_message:, success_message:)
    url = URI(url)
    result = default_get_request_response(url: url, headers: headers)
    status = Net::HTTPResponse::CODE_TO_OBJ[result[:status].to_s]

    status == Net::HTTPOK ? mark_message(success_message) : report_failure(fail_message)
  rescue
    report_failure(fail_message)
  end
  # rubocop:enable Style/RescueStandardError
end

