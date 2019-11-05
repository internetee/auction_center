class DailyBroadcastAuctionsJob < ApplicationJob
  def perform
    User.subscribed_to_daily_summary.each do |user|
      I18n.with_locale(user.locale) do
        NotificationMailer.daily_auctions_broadcast_email(
          recipient: user.email,
          auctions: auctions_today
        ).deliver_later
      end
    end
  end

  def auctions_today
    period = Time.zone.today.beginning_of_day..Time.zone.today.end_of_day
    Auction.started_within(period).to_a
  end

  def self.needs_to_run?
    true
  end
end
