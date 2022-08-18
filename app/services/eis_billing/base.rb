module EisBilling
  class Base
    BASE_URL = AuctionCenter::Application.config
                                         .customization[:billing_system_integration]
                                         &.compact&.fetch(:eis_billing_system_base_url, '')

    INITIATOR = 'auction'.freeze

    ONEOFF_ENDPOINT = AuctionCenter::Application.config
                                                .customization[:billing_system_integration]
                                                &.compact&.fetch(:oneoff_endpoint, '')
    API_USERNAME = AuctionCenter::Application.config
                                             .customization
                                             .dig(:payment_methods, :every_pay, :user)
    KEY = AuctionCenter::Application.config
                                    .customization
                                    .dig(:payment_methods, :every_pay, :key)

    ACCOUNT_NAME = AuctionCenter::Application.config
                                             .customization[:billing_system_integration]
                                             &.compact&.fetch(:account_name, '')


    def self.base_request(url:)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true unless Rails.env.development?
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?

      http
    end

    def self.generate_token
      JWT.encode(payload, billing_secret)
    end

    def self.payload
      { initiator: INITIATOR }
    end

    def self.headers
      {
        'Authorization' => "Bearer #{generate_token}",
        'Content-Type' => 'application/json',
      }
    end

    def self.billing_secret
      AuctionCenter::Application.config.customization[:billing_system_integration]&.compact&.fetch(:billing_secret, '')
    end
  end
end
