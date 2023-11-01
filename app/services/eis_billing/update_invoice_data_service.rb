module EisBilling
  class UpdateInvoiceDataService
    include EisBilling::Request
    include EisBilling::BaseService

    attr_reader :invoice_number, :transaction_amount

    def initialize(invoice_number:, transaction_amount:)
      @invoice_number = invoice_number
      @transaction_amount = transaction_amount
    end

    def self.call(invoice_number:, transaction_amount:)
      new(invoice_number:, transaction_amount:).call
    end

    def call
      struct_response(fetch)
    end

    private

    def fetch
      patch invoice_update_data_url, params
    end

    def params
      { invoice_number:,
        transaction_amount: }
    end

    def invoice_update_data_url
      'api/v1/invoice/update_invoice_data'
    end
  end
end
