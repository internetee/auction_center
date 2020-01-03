require 'messente/sending_error'

module Messente
  class Omnimessage
    BASE_URL = URI('https://api.messente.com/v1/omnimessage')
    HTTP_SUCCESS = '201'

    USERNAME = AuctionCenter::Application.config.customization.dig(:messente, :username)
    PASSWORD = AuctionCenter::Application.config.customization.dig(:messente, :password)
    CHANNEL = 'sms'

    attr_reader :recipient
    attr_reader :text

    def initialize(recipient, text)
      @recipient = recipient
      @text = text
    end

    def request
      @request ||= Net::HTTP::Post.new(
        BASE_URL.path,
        { 'Accept': 'application/json',
          'Content-Type': 'application/json' }
      )
    end

    def body
      { to: recipient, messages: [channel: CHANNEL, text: text] }.to_json
    end

    def send_message
      request.body = body
      request.basic_auth(USERNAME, PASSWORD)

      response = Net::HTTP.start(BASE_URL.host, BASE_URL.port, use_ssl: true) do |http|
        http.request(request)
      end

      body_as_json = JSON.parse(response.body, symbolize_names: true)
      code_as_string = response.code.to_s

      if code_as_string == HTTP_SUCCESS
        [code_as_string, body_as_json]
      else
        raise Messente::SendingError.new(code_as_string, body_as_json, body)
      end
    end
  end
end
