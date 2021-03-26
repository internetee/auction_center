class BanMailer < ApplicationMailer
  def ban_mail(ban, ban_strikes, domain_name)
    @ban = ban
    @user = @ban.user
    @domain_name = domain_name
    invoice = @ban.invoice
    @linkpay_url = invoice.linkpay_url

    I18n.locale = @user.locale
    @past_due_invoices = if I18n.locale == :en
                           ban_strikes.ordinalize
                         else
                           ban_strikes
                         end

    mail(to: @user.email, subject: t('.subject', domain_name: domain_name))
  end
end
