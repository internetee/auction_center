module EisBilling
  class Invoice < EisBilling::Base
    attr_reader :invoice

    def initialize(invoice)
      @invoice = invoice
    end

    def send_invoice
      send_request(json_obj: parse_invoice)
    end

    private

    def parse_invoice
      data = {}
      data[:transaction_amount] = invoice.total.to_s
      data[:order_reference] = invoice.number
      data[:customer_name] = "#{invoice.user.given_names} #{invoice.user.surname}"
      data[:customer_email] = invoice.user.email
      data[:custom_field1] = 'prepended'
      data[:custom_field2] = INITIATOR
      data[:invoice_number] = invoice.number

      data
    end

    def send_request(json_obj:)
      http = EisBilling::Base.base_request(url: invoice_generator_url)
      http.post(invoice_generator_url, json_obj.to_json, EisBilling::Base.headers)
    end

    def invoice_generator_url
      "#{BASE_URL}/api/v1/invoice_generator/invoice_generator"
    end
  end
end
