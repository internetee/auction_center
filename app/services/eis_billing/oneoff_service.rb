module EisBilling
  class OneoffService
    include EisBilling::Request
    include EisBilling::BaseService

    attr_reader :invoice_number, :customer_url, :amount

    def initialize(invoice_number:, customer_url:, amount: nil)
      @invoice_number = invoice_number
      @customer_url = customer_url
      @amount = amount
    end

    def self.call(invoice_number:, customer_url:, amount: nil)
      new(invoice_number: invoice_number, customer_url: customer_url, amount: amount).call
    end

    def call
      struct_response(fetch)
    end

    private

    def fetch
      post invoice_oneoff_url, params
    end

    def params
      {
        invoice_number: invoice_number,
        customer_url: customer_url,
        amount: amount
      }
    end

    def invoice_oneoff_url
      '/api/v1/invoice_generator/oneoff'
    end
  end
end
