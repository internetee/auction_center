class DailyBroadcastAuctionsJob < ApplicationJob
  def perform
    User.subscribed_to_daily_summary.each do |user|
      I18n.with_locale(user.locale) do
        unsubscribe = Rails.application.message_verifier(:unsubscribe).generate(user.id)
        NotificationMailer.daily_auctions_broadcast_email(
          recipient: user.email,
          auctions: active_auctions,
          unsubscribe: unsubscribe
        ).deliver_later
      end
    end
  end

  def active_auctions
    Auction.active.to_a
  end

  def self.needs_to_run?
    true
  end
end
