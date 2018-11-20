module Errors
  class AuctionNotFinished < StandardError
    attr_reader :auction_id, :message

    def initialize(auction_id = nil)
      @auction_id = auction_id
      @message = "Auction with id #{auction_id} is not finished"
      super(message)
    end
  end
end
