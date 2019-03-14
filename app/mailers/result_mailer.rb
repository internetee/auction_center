class ResultMailer < ApplicationMailer
  def winner_email(result)
    @result = result
    @user = result.user
    @auction = result.auction

    mail(to: @user.email, subject: t('.subject'))
  end

  def registration_code_email(result)
    @result = result
    @user = result.user
    @auction = result.auction

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end
end
