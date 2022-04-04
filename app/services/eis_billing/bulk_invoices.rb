module EisBilling
  class BulkInvoices < EisBilling::Base
    INITIATOR = 'auction'.freeze

    def self.generate_link(invoices)
      parsed_data = parse_data(invoices)
      prepared_data = prepare_data(parsed_data: parsed_data)

      send_request(json_obj: prepared_data)
    end

    def self.send_request(json_obj:)
      http = EisBilling::Base.base_request(url: invoice_generator_url)
      http.post(invoice_generator_url, json_obj.to_json, EisBilling::Base.headers)
    end

    def self.invoice_generator_url
      "#{BASE_URL}/api/v1/invoice_generator/invoice_generator"
    end

    def self.parse_data(invoices)
      parsed_data = {}

      data_of_first_invoice = extract_data_from_invoice(invoices[0])
      parsed_data[:customer_name] = data_of_first_invoice[:customer_name]
      parsed_data[:customer_email] = data_of_first_invoice[:customer_email]

      parsed_data[:invoices_total_sum] = total_transaction_amount(invoices)
      parsed_data[:invoice_description] = prepare_description(invoices)

      parsed_data
    end

    def self.prepare_description(invoices)
      data = []
      invoices.each do |i|
        data << i.number.to_s
      end

      data.join(' ')
    end

    def self.extract_data_from_invoice(invoice)
      {
        customer_name: "#{invoice.user.given_names} #{invoice.user.surname}",
        customer_email: invoice.user.email,
      }
    end

    def self.total_transaction_amount(invoices)
      invoices.sum { |invoice| invoice.total.to_i }.to_s
    end

    def self.prepare_data(parsed_data:)
      data = {}

      generated_number_result = EisBilling::GetInvoiceNumber.take_it
      generated_number = JSON.parse(generated_number_result.body, symbolize_names: true)[:invoice_number]

      data[:custom_field1] = parsed_data[:invoice_description]
      data[:transaction_amount] = parsed_data[:invoices_total_sum]
      data[:customer_name] = parsed_data[:customer_name]
      data[:customer_email] = parsed_data[:customer_email]
      data[:custom_field2] = INITIATOR
      data[:order_reference] = generated_number
      data[:invoice_number] = generated_number

      data
    end
  end
end
