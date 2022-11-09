module EisBilling
  class SendInvoiceStatusService
    include EisBilling::Request
    include EisBilling::BaseService

    attr_reader :invoice_number, :status

    def initialize(invoice_number:, status:)
      @invoice_number = invoice_number
      @status = status
    end

    def self.call(invoice_number:, status:)
      new(invoice_number: invoice_number, status: status).call
    end

    def call
      struct_response(send_request)
    end

    def send_request
      payload = {
        invoice_number: invoice_number,
        status: status,
      }

      post invoice_status_url, payload
    end

    def invoice_status_url
      '/api/v1/invoice_generator/invoice_status'
    end
  end
end
