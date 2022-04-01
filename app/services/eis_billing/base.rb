module EisBilling
  class Base
    BASE_URL = AuctionCenter::Application.config
                                         .customization[:billing_system_integration]
                                         &.compact&.fetch(:eis_billing_system_base_url, '')

    INITIATOR = 'auction'.freeze

    def self.base_request(url:)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)

      # unless Rails.env.development? || Rails.env.test?
      #   http.use_ssl = true
      #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      # end

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
