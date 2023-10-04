class WishlistJob < ApplicationJob
  def perform(domain_name, auction_remote_id)
    wishlist_items = WishlistItem.where(domain_name: domain_name)
    auction = Auction.where.not(starts_at: nil).where('ends_at > ?', Time.zone.now)
                     .find_by(remote_id: auction_remote_id)
    return unless auction

    wishlist_items.each do |item|
      next if item.processed?

      WishlistMailer.auction_notification_mail(item, auction)
                    .deliver_later(wait_until: auction.starts_at)
      WishlistAutoOfferJob.set(wait_until: auction.starts_at).perform_later(auction.id)
      item.update(processed: true)
    end
  end
end
