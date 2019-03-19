class ResultMailer < ApplicationMailer
  def winner_email(result)
    @result = result
    @user = result.user
    @auction = result.auction
    I18n.locale = @user.locale

    mail(to: @user.email, subject: t('.subject'))
  end

  def participant_email(recipient, auction)
    @auction = auction
    I18n.locale = recipient.locale

    mail(to: recipient.email, subject: t('.subject', domain_name: @auction.domain_name))
  end

  def registration_code_email(result)
    @result = result
    @user = result.user
    @auction = result.auction
    I18n.locale = @user.locale

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end
end
