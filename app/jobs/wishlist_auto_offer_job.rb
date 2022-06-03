class WishlistAutoOfferJob < ApplicationJob
  def perform(auction_id)
    auction = Auction.find(auction_id)
    return if auction.english?

    FirstBidFromWishlistService.set_bid(auction: auction)

    # item = WishlistItem.find(item_id)

    # return if item.cents.blank?

    # auction = Auction.find(auction_id)

    # return if auction.english?

    # Offer.create!(
    #   auction: auction,
    #   user: item.user,
    #   cents: item.cents,
    #   billing_profile: item.user.billing_profiles.first
    # )
  end
end
