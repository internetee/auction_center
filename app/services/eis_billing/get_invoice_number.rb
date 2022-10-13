module EisBilling
  class GetInvoiceNumber
    include EisBilling::Request
    include EisBilling::BaseService

    def self.call
      new.call
    end

    def call
      struct_response(send_request)
    end

    private

    def send_request
      post invoice_number_generator_url, nil
    end

    def invoice_number_generator_url
      '/api/v1/invoice_generator/invoice_number_generator'
    end
  end
end
