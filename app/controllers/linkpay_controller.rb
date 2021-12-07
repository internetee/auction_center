class LinkpayController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[callback]

  def callback
    save_response
    render status: :ok, json: { status: 'ok' }
  end

  def save_response
    uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    payment_order = if uuid_regex.match?(linkpay_params[:order_reference].to_s.downcase)
                      payment_order_by_uuid
                    else
                      payment_order_by_invoice
                    end

    return unless payment_order

    payment_order.response = {
      order_reference: linkpay_params[:order_reference],
      payment_reference: linkpay_params[:payment_reference],
    }
    payment_order.save
    CheckLinkpayStatusJob.set(wait: 1.minute).perform_later(payment_order.id)
  end

  private

  def payment_order_by_invoice
    invoice = Invoice.find_by(number: linkpay_params[:order_reference])
    payment_reference = linkpay_params[:payment_reference]
    return unless invoice

    find_payment_order(invoice: invoice, ref: payment_reference)
  end

  def payment_order_by_uuid
    PaymentOrder.find_by(uuid: linkpay_params[:order_reference])
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
