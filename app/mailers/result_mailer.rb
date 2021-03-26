class ResultMailer < ApplicationMailer
  def winner_email(result)
    @result = result
    @user = result.user
    @auction = result.auction
    I18n.locale = @user.locale
    @linkpay_url = winner_payment_link(@result)

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end

  def participant_email(recipient, auction)
    @auction = auction
    @user = recipient
    I18n.locale = recipient.locale

    mail(to: recipient.email, subject: t('.subject', domain_name: @auction.domain_name))
  end

  def registration_code_email(result)
    @result = result
    @user = result.user
    @auction = result.auction
    I18n.locale = @user.locale

    mail(to: @user.email, subject: t('.subject', domain_name: @auction.domain_name))
  end

  private

  def winner_payment_link(result)
    return unless PaymentOrder.supported_methods.include?('PaymentOrders::EveryPay'.constantize)

    invoice = result.invoice
    payment_order = PaymentOrders::EveryPay.create(invoices: [invoice])
    payment_order.linkpay_builder
  end
end
