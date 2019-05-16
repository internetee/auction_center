class NotificationMailer < ApplicationMailer
  def daily_summary_email(addressee, summary_report)
    I18n.locale = addressee.locale

    @winning_offers = summary_report.winning_offers
    @results_with_no_bids = summary_report.results_with_no_bids
    @registration_deadlines = summary_report.registration_deadlines
    @bans = summary_report.bans

    mail(to: addressee.email, subject: t('.subject', date: Date.yesterday))
  end
end
