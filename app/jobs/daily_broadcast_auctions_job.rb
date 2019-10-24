class DailyBroadcastAuctionsJob < ApplicationJob
  def perform
    User.where(daily_summary: true).each do |user|
      NotificationMailer.daily_auctions_broadcast_email(
        recipient: user,
        auctions: auctions_today
      ).deliver_later
    end
  end

  def auctions_today
    timeframe = Time.zone.today.beginning_of_day..Time.zone.today.end_of_day
    Auction.where(starts_at: timeframe).to_a
  end

  def self.needs_to_run?
    true
  end
end
