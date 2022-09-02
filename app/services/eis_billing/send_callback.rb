module EisBilling
  class SendCallback
    include EisBilling::Request
    attr_reader :reference_number

    def initialize(reference_number:)
      @reference_number = reference_number
    end

    def self.send(reference_number:)
      fetcher = new(reference_number: reference_number)
      fetcher.send_it
    end

    def send_it
      get billing_callback_url
    end

    def billing_callback_url
      "/api/v1/callback_handler/callback?payment_reference=#{reference_number}"
    end
  end
end
