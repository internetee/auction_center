class BanMailer < ApplicationMailer
  def ban_mail(ban, ban_strikes, domain_name)
    @ban = ban
    @user = @ban.user
    @domain_name = domain_name
    invoice = @ban.invoice
    @linkpay_url = invoice.linkpay_url

    I18n.locale = @user.locale
    @past_due_invoices = I18n.locale == :en ? ban_strikes.ordinalize : ban_strikes

    mail(to: @user.email, subject: t('.subject', domain_name: domain_name))
  end
end
