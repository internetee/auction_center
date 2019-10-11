class DailyBroadcastAuctionsJob < ApplicationJob
  def perform
    User.where(auction_newsletter: true).each do |subscriber|
      NotificationMailer.daily_auctions_broadcast_email(subscriber, auctions_today).deliver_later
    end
  end

  def auctions_today
    timeframe = Time.zone.today.beginning_of_day..Time.zone.today.end_of_day
    Auction.select(:id, :domain_name, :ends_at).where(starts_at: timeframe).to_ary
  end

  def self.needs_to_run?
    true
  end
end
