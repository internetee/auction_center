module EisBilling
  class OneoffService
    include EisBilling::Request
    include EisBilling::BaseService

    attr_reader :invoice_number, :customer_url

    def initialize(invoice_number:, customer_url:)
      @invoice_number = invoice_number
      @customer_url = customer_url
    end

    def self.call(invoice_number:, customer_url:)
      new(invoice_number: invoice_number, customer_url: customer_url).call
    end

    def call
      struct_response(fetch)
    end

    private

    def fetch
      post invoice_oneoff_url, params
    end

    def params
      { invoice_number: invoice_number,
        customer_url: customer_url }
    end

    def invoice_oneoff_url
      '/api/v1/invoice_generator/oneoff'
    end
  end
end
