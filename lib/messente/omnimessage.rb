module Messente
  class Omnimessage
    BASE_URL = URI('https://api.messente.com/v1/omnimessage')

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

    def request
      @request ||= Net::HTTP::Post.new(
        BASE_URL.path,
        {'Accept': 'application/json',
         'Content-Type': 'application/json'}
      )
    end

    def body
      { to: recipient, messages: [channel: channel, text: text] }.to_json
    end

    def send_message
      request.body = body
      request.basic_auth(USERNAME, PASSWORD)

      response = Net::HTTP.start(BASE_URL.host, BASE_URL.port, use_ssl: true) do |http|
        http.request(request)
      end

      [response.code, JSON.parse(response.body, symbolize_names: true)]
    end
  end
end
