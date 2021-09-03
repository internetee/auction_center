module Registry
  class StatusReporter < Base
    attr_reader :result

    def initialize(result)
      @result = result
    end

    def request
      @request ||= Net::HTTP::Patch.new(
        URI.join(BASE_URL, remote_id),
        'Content-Type': 'application/json'
      )
    end

    def call
      return if result_already_reported?
      return if result_can_be_skipped?
      return if remote_id_missing?

      request.body = request_body

      perform_request(request)

      body_as_json = JSON.parse(body_as_string, symbolize_names: true)
      result.update!(last_remote_status: result.status,
                     last_response: body_as_json,
                     registration_code: body_as_json[:registration_code])

      send_registration_code
    end

    private

    def send_registration_code
      return unless result.status == Result.statuses[:payment_received]
      return unless result.registration_code

      ResultMailer.registration_code_email(result).deliver_later
    end

    def result_already_reported?
      result.last_remote_status == result.status
    end

    def result_can_be_skipped?
      result.status == Result.statuses[:domain_registered]
    end

    def remote_id
      result.auction.remote_id
    end

    def remote_id_missing?
      remote_id.nil?
    end

    def request_body
      { status: result.status,
        registration_deadline: registration_deadline }.to_json
    end

    def registration_deadline
      case result.status
      when 'awaiting_payment'
        result.invoice.due_date.end_of_day
      when 'payment_received'
        result.registration_due_date.end_of_day
      end
    end
  end
end
