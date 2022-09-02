module EisBilling
  module Connection
    BASE_URL = AuctionCenter::Application.config
                                         .customization[:billing_system_integration]
                                         &.compact&.fetch(:eis_billing_system_base_url, '')
    INITIATOR = 'auction'.freeze

    def connection
      Faraday.new(options) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    private

    def options
      {
        headers: {
          'Authorization' => "Bearer #{generate_token}",
          'Content-Type' => 'application/json',
        },
        url: BASE_URL,
      }
    end

    def generate_token
      JWT.encode(payload, billing_secret)
    end

    def payload
      { initiator: INITIATOR }
    end

    def billing_secret
      AuctionCenter::Application.config.customization[:billing_system_integration]&.compact&.fetch(:billing_secret, '')
    end
  end
end
