module EisBilling
  class BulkInvoicesService
    include EisBilling::Request
    include EisBilling::BaseService

    INITIATOR = 'auction'.freeze

    attr_reader :invoices

    def initialize(invoices)
      @invoices = invoices
    end

    def self.call(invoices)
      new(invoices).call
    end

    def call
      parsed_data = parse_data(invoices)
      prepared_data = prepare_data(parsed_data: parsed_data)

      response = send_request(payload: prepared_data)
      struct_response(response)
    end

    private

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
      generated_number = EisBilling::GetInvoiceNumber.call

      raise(StandardError, generated_number.errors) unless generated_number.result?

      data[:custom_field1] = parsed_data[:invoice_description]
      data[:transaction_amount] = parsed_data[:invoices_total_sum]
      data[:customer_name] = parsed_data[:customer_name]
      data[:customer_email] = parsed_data[:customer_email]
      data[:custom_field2] = INITIATOR
      data[:order_reference] = generated_number.instance['number']
      data[:invoice_number] = generated_number.instance['number']
      data[:multiple] = 'true'

      data
    end
  end
end
