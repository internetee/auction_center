module EisBilling
  class GetInvoiceNumber
    include EisBilling::Request

    def self.take_it
      fetcher = new
      fetcher.send_request
    end

    def send_request
      post invoice_number_generator_url, nil
    end

    def invoice_number_generator_url
      '/api/v1/invoice_generator/invoice_number_generator'
    end
  end
end
