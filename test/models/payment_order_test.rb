require 'test_helper'

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
end
