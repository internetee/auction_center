class DomainRegistrationMailer < ApplicationMailer
  def registration_reminder_email(result)
    @result = result
    @user = result.user
    @domain_name = result.auction.domain_name
    I18n.locale = @user.locale

    mail(to: @user.email, subject: t('.subject', domain_name: @domain_name))

    @result.update!(registration_reminder_sent_at: Time.zone.now)
  end
end
