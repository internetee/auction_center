class DomainRegistrationMailer < ApplicationMailer
  def registration_reminder_email(result)
    @result = result
    @user = result.user || User.first
    @domain_name = result.auction.domain_name
    I18n.locale = @user&.locale

    I18n.with_locale(I18n.locale) do
      @days_count = days_count(result)
    end

    mail(to: @user.email, subject: subject)

    @result.update!(registration_reminder_sent_at: Time.zone.now)
  end

  def subject
    t('domain_registration_mailer.registration_reminder_email.subject', domain_name: @domain_name)
  end

  def days_count(result)
    days = (result.registration_due_date - Time.zone.now.to_date).to_i
    if days > 1
      t('domain_registration_mailer.registration_reminder_email.more_days', days: days)
    elsif days == 1
      t('domain_registration_mailer.registration_reminder_email.one_day')
    else
      t('domain_registration_mailer.registration_reminder_email.last_day')
    end
  end
end
