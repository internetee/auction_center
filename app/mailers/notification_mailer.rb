class NotificationMailer < ApplicationMailer
  def daily_summary_email(addressee, summary_report = nil)
    I18n.locale = addressee.locale

    summary_report ||= create_summary_report_if_needed
    @winning_offers = summary_report.winning_offers
    @results_with_no_bids = summary_report.results_with_no_bids
    @registration_deadlines = summary_report.registration_deadlines
    @bans = summary_report.bans
    @user = addressee

    mail(to: addressee.email, subject: t('.subject', date: Date.yesterday))
  end

  def daily_auctions_broadcast_email(recipient:, auctions:, unsubscribe: nil)
    @auctions = auctions
    @unsubscribe = unsubscribe
    mail(to: recipient)
  end

  private

  def create_summary_report_if_needed
    twelve_hours = 12 * 3600
    today = Time.zone.today.midnight
    yesterday_at_noon = today - twelve_hours
    SummaryReport.new(yesterday_at_noon, Time.zone.now)
  end
end
