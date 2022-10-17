module EisBilling
  class Invoice
    include EisBilling::Request
    include EisBilling::BaseService

    attr_reader :invoice

    def initialize(invoice:)
      @invoice = invoice
    end

    def self.call(invoice:)
      new(invoice: invoice).call
    end

    def call
      struct_response(send_request)
    end

    private

    def params
      data = {}
      data[:transaction_amount] = invoice.total.to_f.to_s
      data[:order_reference] = invoice.number
      data[:customer_name] = "#{invoice.user.given_names} #{invoice.user.surname}"
      data[:customer_email] = invoice.user.email
      data[:custom_field1] = 'prepended'
      data[:custom_field2] = INITIATOR
      data[:invoice_number] = invoice.number

      data
    end

    def send_request
      post invoice_generator_url, params
    end

    def invoice_generator_url
      '/api/v1/invoice_generator/invoice_generator'
    end
  end
end
