class InvoiceMailer < ApplicationMailer
  def reminder_email(invoice)
    @invoice = invoice
    @user = invoice.user
    @auction = invoice.result.auction
    @linkpay_url = invoice.linkpay_url

    I18n.locale = @user&.locale || 'en'

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end

  def refund_failed(auction, user, error_message)
    # @invoice = invoice
    @user = user
    @auction = auction
    @error_message = error_message

    I18n.locale = @user&.locale || 'en'

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end
end
