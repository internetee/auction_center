class WishlistAutoOfferJob < ApplicationJob
  def perform(item_id, auction_id)
    item = WishlistItem.find(item_id)

    return if item.cents.blank?

    auction = Auction.find(auction_id)
    Offer.create!(auction: auction, user: item.user, cents: item.cents, billing_profile: item.user.billing_profiles.first)
  end
end
