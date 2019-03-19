class BanMailer < ApplicationMailer
  def ban_email(ban)
    @ban = ban
    @user = @ban.user
    I18n.locale = @user.locale

    mail(to: @user.email, subject: t('.subject'))
  end
end
