require 'test_helper'

class PaymentOrderTest < ActiveSupport::TestCase
  def setup
    super

    @payable_invoice = invoices(:payable)
    @user = users(:participant)
  end

  def test_required_fields
    payment_order = PaymentOrder.new
    assert_not(payment_order.valid?)

    payment_order.invoices << @payable_invoice
    payment_order.user = @user
    payment_order.type = 'PaymentOrders::EveryPay'

    assert(payment_order.valid?, payment_order.errors.full_messages)
  end

  def test_default_status_is_issued
    payment_order = PaymentOrder.new
    assert_equal(PaymentOrder.statuses[:issued], payment_order.status)
  end

  def test_allowed_types_are_taken_from_config
    assert(PaymentOrder::ENABLED_METHODS.include? 'PaymentOrders::EveryPay')
  end

  def test_supported_method_returns_true_or_false
    assert(PaymentOrder.supported_method?(PaymentOrders::EveryPay))
  end

  def test_payment_method_must_be_supported_for_the_object_to_be_valid
    payment_order = PaymentOrder.new

    payment_order.invoices << @payable_invoice
    payment_order.user = @user
    payment_order.type = 'PaymentOrders::EveryPay'

    assert(payment_order.valid?)

    payment_order.type = 'PaymentOrders::Manual'
    assert_not(payment_order.valid?)
  end

  def test_invoice_cannot_be_already_paid
    payment_order = PaymentOrder.new

    payment_order.invoices << @payable_invoice
    payment_order.user = @user
    payment_order.type = 'PaymentOrders::EveryPay'

    assert(payment_order.valid?)

    @payable_invoice.mark_as_paid_at(Time.zone.now)

    assert_not(payment_order.valid?)
  end
end
