class WishlistJob < ApplicationJob
  LONG_WAIT_TIME = 2.hours
  SHORT_WAIT_TIME = 1.minute

  def perform(domain_name, auction_remote_id)
    wishlist_items = WishlistItem.where(domain_name: domain_name)
    auction = Auction.where('ends_at > ?', Time.zone.now)
                     .find_by(remote_id: auction_remote_id)
    return unless auction

    wishlist_items.each do |item|
      WishlistMailer.auction_notification_mail(item, auction).deliver_later
      WishlistAutoOfferJob.set(wait_until: auction.starts_at).perform_later(auction.id)
    end
  end

  def self.wait_time
    Rails.env.production? ? LONG_WAIT_TIME : SHORT_WAIT_TIME
  end
end
