class CheckLinkpayStatusJob < ApplicationJob
  retry_on(*Bundler::Fetcher::HTTP_ERRORS)

  def perform(payment_order_id)
    payment_order = PaymentOrder.find(payment_order_id)
    return unless payment_order_valid?(payment_order)

    EisBilling::SendCallbackService.call(reference_number: payment_order.response['payment_reference'])
  end

  private

  def payment_order_valid?(order)
    order.present? && order.is_a?(PaymentOrders::EveryPay) && order.response.present?
  end
end
