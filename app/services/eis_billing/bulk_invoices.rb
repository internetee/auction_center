module EisBilling
  class BulkInvoices
    include EisBilling::Request
    INITIATOR = 'auction'.freeze

    attr_reader :invoices

    def initialize(invoices)
      @invoices = invoices
    end

    def self.call(invoices)
      fetcher = new(invoices)
      parsed_data = fetcher.parse_data(invoices)
      prepared_data = fetcher.prepare_data(parsed_data: parsed_data)

      fetcher.send_request(payload: prepared_data)
    end

    def send_request(payload:)
      post invoice_generator_url, payload
    end

    def invoice_generator_url
      '/api/v1/invoice_generator/invoice_generator'
    end

    def parse_data(invoices)
      parsed_data = {}

      data_of_first_invoice = extract_data_from_invoice(invoices[0])
      parsed_data[:customer_name] = data_of_first_invoice[:customer_name]
      parsed_data[:customer_email] = data_of_first_invoice[:customer_email]
      parsed_data[:invoices_total_sum] = total_transaction_amount(invoices)
      parsed_data[:invoice_description] = prepare_description(invoices)

      parsed_data
    end

    def prepare_description(invoices)
      data = []
      invoices.each do |i|
        data << i.number.to_s
      end

      data.join(' ')
    end

    def extract_data_from_invoice(invoice)
      {
        customer_name: "#{invoice.user.given_names} #{invoice.user.surname}",
        customer_email: invoice.user.email,
      }
    end

    def total_transaction_amount(invoices)
      invoices.sum { |invoice| invoice.total.to_f }.to_s
    end

    def prepare_data(parsed_data:)
      data = {}
      generated_number = EisBilling::GetInvoiceNumber.call['invoice_number']

      data[:custom_field1] = parsed_data[:invoice_description]
      data[:transaction_amount] = parsed_data[:invoices_total_sum]
      data[:customer_name] = parsed_data[:customer_name]
      data[:customer_email] = parsed_data[:customer_email]
      data[:custom_field2] = INITIATOR
      data[:order_reference] = generated_number
      data[:invoice_number] = generated_number
      data[:multiple] = 'true'

      data
    end
  end
end
