module Errors
  class AuctionNotFound < StandardError
    attr_reader :auction_id, :message

    def initialize(auction_id = nil)
      @auction_id = auction_id
      @message = "Auction with id #{auction_id} does not exist"
      super(message)
    end
  end
end
