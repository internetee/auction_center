module EisBilling
  class GetReferenceNumber
    include EisBilling::Request
    include EisBilling::BaseService

    attr_reader :email, :owner

    def initialize(email:, owner:)
      @email = email
      @owner = owner
    end

    def self.call(email:, owner:)
      new(email:, owner:).call
    end

    def call
      struct_response(send_request)
    end

    private

    def send_request
      post reference_number_generator_url, payload
    end

    def reference_number_generator_url
      '/api/v1/invoice_generator/reference_number_generator'
    end

    def payload
      {
        initiator: 'auction',
        email:,
        owner:
      }
    end
  end
end
