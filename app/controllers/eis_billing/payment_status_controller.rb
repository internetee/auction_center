module EisBilling
  class PaymentStatusController < EisBilling::BaseController
    def update
      invoice = ::Invoice.find_by(number: params[:order_reference])
      payment_reference = params[:payment_reference]

      return unless PaymentOrder.supported_methods.include?('PaymentOrders::EveryPay'.constantize)

      if params[:invoice_number_collection].empty?
        payment_process(invoice: invoice, payment_reference: payment_reference) if invoice.present?
      else
        pay_mulitply(params[:invoice_number_collection])
      end

      return unless invoice

      render status: :ok, json: { message: 'payment updated' }
    end

    private

    def pay_mulitply(data)
      return if data.empty?

      data.each do |d|
        invoice = Invoice.find_by(number: d[:number])
        payment_process(invoice: invoice, payment_reference: d[:payment_reference])
      end
    end

    def payment_process(invoice:, payment_reference:)
      payment_order = find_payment_order(invoice: invoice, ref: payment_reference)

      payment_order.response = {
        order_reference: params[:order_reference],
        payment_reference: params[:payment_reference],
      }
      payment_order.save

      check_payment_status(payment_order.id)
    end

    def check_payment_status(payment_order_id)
      if Rails.env.development? || Rails.env.test?
        CheckLinkpayStatusJob.perform_now(payment_order_id)
      else
        CheckLinkpayStatusJob.set(wait: 1.minute).perform_later(payment_order_id)
      end
    end

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
