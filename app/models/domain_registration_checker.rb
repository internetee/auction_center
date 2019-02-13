require 'status_report_failed'

class DomainRegistrationChecker
  BASE_URL = URI('http://registry:3000/api/v1/auctions/')
  HTTP_SUCCESS = '200'

  attr_reader :result

  def initialize(result)
    @result = result
  end

  def call
    response = Net::HTTP.start(BASE_URL.host, BASE_URL.port) do |http|
      http.request(request)
    end

    body_as_string = response.body
    code_as_string = response.code.to_s

    if code_as_string == HTTP_SUCCESS
      body_as_json = JSON.parse(body_as_string, symbolize_names: true)

      if domain_registered?(body_as_json)
        result.update!(status: Result.statuses[:domain_registered],
                       last_response: body_as_json)
      end

      if domain_not_registered?(body_as_json)
        result.update!(status: Result.statuses[:domain_not_registered],
                       last_response: body_as_json)
      end
    else
      raise Errors::StatusReportFailed.new(result.id, body_as_string, code_as_string)
    end
  end

  def request
    @request ||= Net::HTTP::Get.new(
      URI.join(BASE_URL, remote_id),
      { 'Content-Type': 'application/json' }
    )
  end

  private

  def domain_registered?(json)
    json[:status] == 'domain_registered'
  end

  def domain_not_registered?(json)
    Date.today > (result.created_at.to_date + Setting.registration_term) &&
    json[:status] == 'awaiting_payment'
  end

  def remote_id
    result.auction.remote_id
  end
end
