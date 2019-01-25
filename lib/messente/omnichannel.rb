module Messente
  class Omnichannel
    URI = AuctionCenter::Application.config.customization.dig('messente', 'uri')

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
  end
end
