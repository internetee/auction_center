require 'test_helper'

class PaymentOrderTest < ActiveSupport::TestCase
  def setup
    super

    @payable_invoice = invoices(:payable)
    @user = users(:participant)

    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
      .to_return(status: 200, body: @message.to_json, headers: {})
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
