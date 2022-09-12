class InvoiceMailer < ApplicationMailer
  def reminder_email(invoice)
    @invoice = invoice
    @user = invoice.user
    @auction = invoice.result.auction
    @linkpay_url = invoice.payment_link

    I18n.locale = @user&.locale || 'en'

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end
end
