class DailyBroadcastAuctionsJob < ApplicationJob
  def perform
    list = new_auctions
    User.where(auction_newsletter: true).each do |subscriber|
      NotificationMailer.daily_auctions_broadcast_email(subscriber.email, list).perform_later
    end
  end

  def new_auctions
    Auction.where(
      starts_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day,
      ends_at: Time.zone.today.all_day
    )
  end

  def self.needs_to_run?
    true
  end
end
