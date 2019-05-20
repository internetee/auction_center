class WishlistJob < ApplicationJob
  DEFAULT_WAIT_TIME = 2.hours

  def perform(domain_name, auction_remote_id)
    wishlist_items = WishlistItem.where(domain_name: domain_name)
    auction = Auction.active.find_by(remote_id: auction_remote_id)

    wishlist_items.each do |item|
      WishlistMailer.auction_notification_mail(item, auction).deliver_later
    end
  end
end
