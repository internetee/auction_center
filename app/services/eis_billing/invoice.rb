module EisBilling
  class Invoice < EisBilling::Base
    attr_reader :invoice

    def initialize(invoice)
      @invoice = invoice
    end

    def send_invoice
      base_request(json_obj: parse_invoice)
    end

    private

    def parse_invoice
      data = {}
      data[:transaction_amount] = invoice.total.to_s
      data[:order_reference] = invoice.number
      data[:customer_name] = invoice.user.name
      data[:customer_email] = invoice.user.email
      data[:custom_field_1] = invoice.notes
      data[:custom_field_2] = 'auction'
      data[:invoice_number] = invoice.number

      data
    end

    def base_request(json_obj:)
      uri = URI(invoice_generator_url)
      http = Net::HTTP.new(uri.host, uri.port)
      headers = {
        'Authorization' => 'Bearer foobar',
        'Content-Type' => 'application/json',
        'Accept' => TOKEN
      }

      res = http.post(invoice_generator_url, json_obj.to_json, headers)
      res
    end

    def invoice_generator_url
      "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator"
    end
  end
end
