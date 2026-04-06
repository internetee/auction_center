require 'test_helper'

class CheckLinkpayStatusJobTest < ActiveJob::TestCase
  def test_perform_sends_callback_for_everypay_payment_order_with_response
    payment_order = PaymentOrders::EveryPay.new
    payment_order.define_singleton_method(:response) { { 'payment_reference' => 'PAYREF-3' } }

    PaymentOrder.stub(:find, payment_order) do
      EisBilling::SendCallbackService.stub(:call, true) do
        CheckLinkpayStatusJob.perform_now(123)
      end
    end

    assert true
  end

  def test_perform_does_not_send_callback_for_non_everypay_order
    payment_order = PaymentOrder.new
    payment_order.define_singleton_method(:response) { { 'payment_reference' => 'PAYREF-4' } }

    PaymentOrder.stub(:find, payment_order) do
      EisBilling::SendCallbackService.stub(:call, ->(*) { raise 'should not be called' }) do
        CheckLinkpayStatusJob.perform_now(123)
      end
    end

    assert true
  end

  def test_perform_does_not_send_callback_when_response_missing
    payment_order = PaymentOrders::EveryPay.new
    payment_order.define_singleton_method(:response) { nil }

    PaymentOrder.stub(:find, payment_order) do
      EisBilling::SendCallbackService.stub(:call, ->(*) { raise 'should not be called' }) do
        CheckLinkpayStatusJob.perform_now(123)
      end
    end

    assert true
  end
end
