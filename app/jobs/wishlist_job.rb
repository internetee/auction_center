class WishlistJob < ApplicationJob
  LONG_WAIT_TIME = 2.hours
  SHORT_WAIT_TIME = 1.minute

  def perform(domain_name, auction_remote_id)
    wishlist_items = WishlistItem.where(domain_name: domain_name)
    auction = Auction.active.find_by(remote_id: auction_remote_id)
    return unless auction

    wishlist_items.each do |item|
      WishlistMailer.auction_notification_mail(item, auction).deliver_later
    end
  end

  # Consider different management of this property.
  def self.wait_time
    if Rails.env == 'production'
      LONG_WAIT_TIME
    else
      SHORT_WAIT_TIME
    end
  end
end
