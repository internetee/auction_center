class BanMailer < ApplicationMailer
  def ban_mail(ban, ban_strikes, domain_name)
    @ban = ban
    @user = @ban.user
    @domain_name = domain_name

    I18n.locale = @user.locale
    @past_due_invoices = I18n.locale == :en ? ban_strikes.ordinalize : ban_strikes

    mail(to: @user.email, subject: t('.subject', domain_name: domain_name))
  end

  def final_ban_mail(ban, ban_strikes, domain_name)
    @ban = ban
    @user = @ban.user
    @domain_name = domain_name

    I18n.locale = @user.locale
    @past_due_invoices = I18n.locale == :en ? ban_strikes.ordinalize : ban_strikes
    @ban_end_date = I18n.l(@ban.valid_until.to_date)

    mail(to: @user.email, subject: t('.subject', domain_name: domain_name))
  end
end
