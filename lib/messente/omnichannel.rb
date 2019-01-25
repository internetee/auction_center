module Messente
  class Omnichannel
    BASE_URI = AuctionCenter::Application.config.customization.dig('messente', 'uri')
    SSL_PORT = 443

    USERNAME = AuctionCenter::Application.config.customization.dig('messente', 'username')
    PASSWORD = AuctionCenter::Application.config.customization.dig('messente', 'password')

    attr_reader :channel
    attr_reader :recipient
    attr_reader :text

    def initialize(channel, recipient, text)
      @channel = channel
      @recipient = recipient
      @text = text
    end

    def send
      # no-op
    end

    def request
      @request ||= Net::HTTP.new(BASE_URI, SSL_PORT)
    end
  end
end
