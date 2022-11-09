class LinkpayController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[callback]

  def callback
    EisBilling::SendCallbackService.call(reference_number: linkpay_params[:payment_reference])

    redirect_to invoices_path(state: 'payment')
  end

  def deposit_callback
    EisBilling::SendCallbackService.call(reference_number: linkpay_params[:payment_reference])

    redirect_to auctions_path
  end

  private

  def linkpay_params
    params.permit(:order_reference, :payment_reference)
  end
end
