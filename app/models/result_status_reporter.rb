require 'status_report_failed'

class ResultStatusReporter
  BASE_URL = URI('http://registry:3000/api/v1/auctions/')
  HTTP_SUCCESS = '200'

  attr_reader :result

  def initialize(result)
    @result = result
  end

  def request
    @request ||= Net::HTTP::Put.new(
      URI.join(BASE_URL, remote_id),
      { 'Content-Type': 'application/json' }
    )
  end

  def call
    return if result_already_reported?
    return if result_can_be_skipped?

    request.body = request_body

    response = Net::HTTP.start(BASE_URL.host, BASE_URL.port) do |http|
      http.request(request)
    end

    body_as_string = response.body
    code_as_string = response.code.to_s

    if code_as_string == HTTP_SUCCESS
      body_as_json = JSON.parse(body_as_string, symbolize_names: true)
      result.update!(last_remote_status: result.status,
                     last_response: body_as_json,
                     registration_code: body_as_json[:registration_code])
    else
      raise Errors::StatusReportFailed.new(result.id, body_as_string, code_as_string)
    end
  end

  private

  def result_already_reported?
    result.last_remote_status == result.status
  end

  def result_can_be_skipped?
    result.status == Result.statuses[:domain_registered]
  end

  def remote_id
    result.auction.remote_id
  end

  def request_body
    { status: result.status }.to_json
  end
end
