module EisBilling
  class PayDepositService
    include EisBilling::Request
    include EisBilling::BaseService

    INITIATOR = 'auction'.freeze

    attr_reader :amount,
                :customer_url,
                :description

    def initialize(amount:, customer_url:, description:)
      @amount = amount
      @customer_url = customer_url
      @description = description
    end

    def self.call(amount:, customer_url:, description:)
      new(amount: amount, customer_url: customer_url, description: description).call
    end

    def call
      struct_response(send_request)
    end

    private

    def send_request
      post deposit_prepayment_url, params
    end

    def params
      {
        transaction_amount: amount,
        customer_url: customer_url,
        description: description,
        custom_field2: INITIATOR,
        affiliation: 'auction_deposit',
      }
    end

    def deposit_prepayment_url
      '/api/v1/invoice_generator/deposit_prepayment'
    end
  end
end
