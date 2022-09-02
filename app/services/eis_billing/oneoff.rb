module EisBilling
  class Oneoff
    include EisBilling::Request
    attr_reader :invoice_number, :customer_url

    def initialize(invoice_number:, customer_url:)
      @invoice_number = invoice_number
      @customer_url = customer_url
    end

    def self.send_invoice(invoice_number:, customer_url:)
      fetcher = new(invoice_number: invoice_number, customer_url: customer_url)
      fetcher.send_it
    end

    def send_it
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
