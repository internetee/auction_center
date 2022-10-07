module EisBilling
  class PayDepositService
    include EisBilling::Request

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
      fetcher = new(amount: amount, customer_url: customer_url, description: description)
      fetcher.send_request
    end

    def send_request
      post deposit_prepayment_url, params
    end

    def params
      {
        transaction_amount: amount,
        customer_url: customer_url,
        description: description,
        custom_field2: INITIATOR
      }
    end

    def deposit_prepayment_url
      '/api/v1/invoice_generator/deposit_prepayment'
    end
  end
end
