class NotificationMailer < ApplicationMailer
  def daily_summary_email(addressee)
    I18n.locale = addressee.locale

    mail(to: addressee.email, subject: t('.subject', date: Date.yesterday))
  end
end
