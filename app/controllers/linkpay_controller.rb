class LinkpayController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[callback]

  def callback
    Rails.logger.info('=============')
    Rails.logger.info(linkpay_params)
    Rails.logger.info('=============')

    EisBilling::SendCallbackService.call(reference_number: linkpay_params[:payment_reference])

    Rails.logger.info('=============')
    Rails.logger.info(' After Send callback')
    Rails.logger.info('=============')

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
