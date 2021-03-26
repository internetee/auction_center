class InvoiceMailer < ApplicationMailer
  def reminder_email(invoice)
    @invoice = invoice
    @user = invoice.user
    @auction = invoice.result.auction
    @linkpay_url = invoice.linkpay_url

    I18n.locale = @user.locale

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end
end
