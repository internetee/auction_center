class BanMailer < ApplicationMailer
  def ban_email(ban)
    @ban = ban
    @user = @ban.user

    mail(to: @user.email, subject: t('.subject'))
  end
end
