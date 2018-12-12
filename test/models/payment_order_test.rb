require 'test_helper'
require 'expected_payment_order'

class PaymentOrderTest < ActiveSupport::TestCase
  def setup
    super

    @payable_invoice = invoices(:payable)
    @user = users(:participant)
  end

  def test_required_fields
    payment_order = PaymentOrder.new
    refute(payment_order.valid?)

    assert_equal(['must exist'], payment_order.errors[:invoice], payment_order.errors.full_messages)

    payment_order.invoice = @payable_invoice
    payment_order.user = @user

    assert(payment_order.valid?, payment_order.errors.full_messages)
  end

  def test_default_status_is_issued
    payment_order = PaymentOrder.new
    assert_equal(PaymentOrder.statuses[:issued], payment_order.status)
  end

  def test_allowed_types_are_taken_from_config
    assert_equal(['PaymentOrders::EveryPay'], PaymentOrder::ENABLED_METHODS)
  end

  def test_supported_method_raises_error_on_wrong_superclass
    assert_raises Errors::ExpectedPaymentOrder do
      PaymentOrder.supported_method?(Auction)
    end
  end

  def test_supported_method_returns_true_or_false
    assert(PaymentOrder.supported_method?(PaymentOrders::EveryPay))
  end
end
