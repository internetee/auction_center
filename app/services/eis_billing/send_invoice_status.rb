module EisBilling
  class SendInvoiceStatus
    include EisBilling::Request

    def self.send_info(invoice_number:, status:)
      fetcher = new
      fetcher.send_request(invoice_number: invoice_number, status: status)
    end

    def send_request(invoice_number:, status:)
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
