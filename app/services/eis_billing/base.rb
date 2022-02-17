module EisBilling
  class Base
    BASE_URL = ''
    if Rails.env.staging?
      BASE_URL = AuctionCenter::Application.config
                                             .customization[:billing_system_integration]
                                             &.compact&.fetch(:eis_billing_system_base_url_staging, '')
    else
      BASE_URL = AuctionCenter::Application.config
                                             .customization[:billing_system_integration]
                                             &.compact&.fetch(:eis_billing_system_base_url_dev, '')
    end

    INITIATOR = 'auction'

    SECRET_WORD = AuctionCenter::Application.config
                                              .customization[:billing_system_integration]
                                              &.compact&.fetch(:secret_word, '')
    SECRET_ACCESS_WORD = AuctionCenter::Application.config
                                                     .customization[:billing_system_integration]
                                                     &.compact&.fetch(:secret_access_word, '')

    def self.base_request(url:)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)

      unless Rails.env.development? || Rails.env.test?
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http
    end

    def self.generate_token
      JWT.encode(payload, SECRET_WORD )
    end

    def self.payload
      { data: SECRET_ACCESS_WORD }
    end

    def self.headers
      {
      'Authorization' => "Bearer #{generate_token}",
      'Content-Type' => 'application/json',
      }
    end
  end
end
