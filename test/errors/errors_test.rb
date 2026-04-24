require 'test_helper'

class ErrorsTest < ActiveSupport::TestCase
  def test_expected_payment_order_includes_provided_class_in_message
    error = Errors::ExpectedPaymentOrder.new(String)

    assert_equal 'String', error.provided_class
    assert_includes error.message, 'Expected String'
    assert_includes error.message, 'descendant of PaymentOrder'
  end

  def test_invoice_already_paid_includes_id_in_message
    error = Errors::InvoiceAlreadyPaid.new(123)

    assert_equal 123, error.invoice_id
    assert_includes error.message, 'Invoice with id 123 is already paid'
  end
end
