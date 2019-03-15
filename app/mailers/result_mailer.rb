class ResultMailer < ApplicationMailer
  def winner_email(result)
    @result = result
    @user = result.user
    @auction = result.auction

    mail(to: @user.email, subject: t('.subject'))
  end

  def participant_email(result)
    @auction = result.auction

    recipients = User.joins(:offers)
                     .where(offers: { auction_id: @auction.id })
                     .where('users.id <> ?', result.user_id)

    recipient_emails = recipients.pluck(:email)

    mail(to: Rails.application.config.customization['email_from_address'],
         bcc: recipient_emails,
         subject: t('.subject', domain_name: @auction.domain_name))
  end

  def registration_code_email(result)
    @result = result
    @user = result.user
    @auction = result.auction

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end
end
