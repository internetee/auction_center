class LinkpayController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[callback]

  def callback
    save_response
    render status: :ok, json: { status: 'ok' }
  end

  def save_response
    payment_order = PaymentOrder.find(linkpay_params[:order_reference].to_i)
    return unless payment_order

    payment_order.response = {
      order_reference: linkpay_params[:order_reference],
      payment_reference: linkpay_params[:payment_reference],
    }
    payment_order.save
    CheckLinkpayStatusJob.perform_now(payment_order.id)
  end

  def linkpay_params
    params.permit(:order_reference, :payment_reference)
  end
end
