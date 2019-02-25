module Registry
  class RegistrationChecker < Base
    attr_reader :result
    attr_reader :body_as_json

    def initialize(result)
      @result = result
      @result.update!(status: Result.statuses[:payment_received])
    end

    def call
      return if remote_id_missing?

      perform_request(request)

      @body_as_json = JSON.parse(body_as_string, symbolize_names: true)

      if domain_registered?(body_as_json)
        update_result_with_status(Result.statuses[:domain_registered])
      elsif domain_not_registered?(body_as_json)
        update_result_with_status(Result.statuses[:domain_not_registered])
      end
    end

    def request
      @request ||= Net::HTTP::Get.new(
        URI.join(BASE_URL, remote_id),
        'Content-Type': 'application/json'
      )
    end

    private

    def update_result_with_status(status)
      result.update!(status: status, last_response: body_as_json)
    end

    def domain_registered?(json)
      json[:status] == 'domain_registered'
    end

    def domain_not_registered?(json)
      Time.zone.today > (result.created_at.to_date + Setting.registration_term) &&
        json[:status] == 'payment_received'
    end

    def remote_id
      result.auction.remote_id
    end

    def remote_id_missing?
      remote_id.nil?
    end
  end
end
