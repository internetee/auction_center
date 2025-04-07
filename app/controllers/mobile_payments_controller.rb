class MobilePaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[callback]

  def callback
    Rails.logger.info '------ SendCallbackService ----'
    EisBilling::SendCallbackService.call(reference_number: linkpay_params[:payment_reference])
    Rails.logger.info '------ SendCallbackService ----'

    redirect_to mobile_payments_path
  end

  def deposit_callback
    EisBilling::SendCallbackService.call(reference_number: linkpay_params[:payment_reference])

    redirect_to mobile_payments_path
  end

  def index; end

  private

  def linkpay_params
    params.permit(:order_reference, :payment_reference)
  end
end
