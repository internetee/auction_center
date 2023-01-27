class InvoiceMailer < ApplicationMailer
  def reminder_email(invoice)
    @invoice = invoice
    @user = invoice.user
    @auction = invoice.result.auction
    @linkpay_url = invoice.linkpay_url

    I18n.locale = @user&.locale || 'en'

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end

  def refund_failed(admin_emails, auction, user, error_message)
    @admin_emails = admin_emails
    @user = user
    @auction = auction
    @error_message = error_message

    I18n.locale = @user&.locale || 'en'

    mail(to: @admin_emails, subject: 'Deposit refund failed')
  end
end
