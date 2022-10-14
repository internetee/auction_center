module EisBilling
  class BulkInvoicesService
    include EisBilling::Request
    include EisBilling::BaseService

    INITIATOR = 'auction'.freeze

    attr_reader :invoices,
                :customer_url

    def initialize(invoices:, customer_url:)
      @invoices = invoices
      @customer_url = customer_url
    end

    def self.call(invoices:, customer_url:)
      new(invoices: invoices, customer_url: customer_url).call
    end

    def call
      struct_response(send_request)
    end

    private

    def send_request
      post invoice_generator_url, params
    end

    def invoice_generator_url
      '/api/v1/invoice_generator/bulk_payment'
    end

    def params
      {
        transaction_amount: total_transaction_amount(invoices),
        customer_url: customer_url,
        description: prepare_description(invoices),
        custom_field2: INITIATOR
      }
    end

    def prepare_description(invoices)
      data = []
      invoices.each do |i|
        data << i.number.to_s
      end

      data.join(' ')
    end

    def total_transaction_amount(invoices)
      invoices.sum { |invoice| invoice.total.to_f }.to_s
    end
  end
end
