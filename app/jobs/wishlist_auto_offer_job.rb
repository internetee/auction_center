class WishlistAutoOfferJob < ApplicationJob
  def perform(auction_id)
    auction = Auction.find(auction_id)
    return if auction.english?

    FirstBidFromWishlistService.set_bid(auction: auction)
  end
end
