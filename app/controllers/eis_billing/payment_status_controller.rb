module EisBilling
  class PaymentStatusController < EisBilling::BaseController
    def update
      invoice = ::Invoice.find_by(number: params[:order_reference])
      payment_reference = params[:payment_reference]

      return unless invoice
      return unless PaymentOrder.supported_methods.include?('PaymentOrders::EveryPay'.constantize)

      payment_order = find_payment_order(invoice: invoice, ref: payment_reference)

      payment_order.response = {
        order_reference: params[:order_reference],
        payment_reference: params[:payment_reference]
      }
      payment_order.save

      if Rails.env.development? || Rails.env.test?
        CheckLinkpayStatusJob.perform_now(payment_order.id)
      else
        CheckLinkpayStatusJob.set(wait: 1.minute).perform_later(payment_order.id)
      end

      render status: 200, json: { status: 'ok' }
    end

    private

    def find_payment_order(invoice:, ref:)
      order = invoice.payment_orders.every_pay.for_payment_reference(ref).first
      return order if order

      PaymentOrders::EveryPay.create(invoices: [invoice], user: invoice.user)
    end

    def linkpay_params
      params.permit(:order_reference, :payment_reference)
    end
  end
end
