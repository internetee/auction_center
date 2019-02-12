module Errors
  class AuctionCreatorFailed < StandardError
    attr_reader :response_body, :response_code, :message

    def initialize(response_body, response_code)
      @response_body = response_body
      @response_code = response_code

      @message = <<~TEXT.squish
        Registry response failure for Auction list. Response code: #{response_code},
        body: #{response_body}
      TEXT

      super(message)
    end
  end
end
