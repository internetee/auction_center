class MobilePaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[callback]

  def callback
    EisBilling::SendCallbackService.call(reference_number: linkpay_params[:payment_reference])

    redirect_to mobile_payments_path
  end

  def index; end
end
