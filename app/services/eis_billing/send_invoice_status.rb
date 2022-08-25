module EisBilling
  class SendInvoiceStatus < EisBilling::Base
    include EisBilling::Request

    def self.send_info(invoice_number:, status:)
      fetcher = new
      fetcher.send_request(invoice_number: invoice_number, status: status)
    end

    def send_request(invoice_number:, status:)
      json_obj = {
        invoice_number: invoice_number,
        status: status,
      }

      # http = EisBilling::Base.base_request(url: invoice_status_url)
      # http.post(invoice_status_url, json_obj.to_json, EisBilling::Base.headers)
      post invoice_status_url, json_obj
    end

    def invoice_status_url
      "/api/v1/invoice_generator/invoice_status"
    end
  end
end
