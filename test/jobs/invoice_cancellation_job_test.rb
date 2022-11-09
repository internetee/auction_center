require 'test_helper'

class InvoiceCancellationJobTest < ActiveJob::TestCase
  def setup
    super

    @invoice = invoices(:orphaned)
  end

  def test_overdue_invoices_are_cancelled_automatically
    message = {
      message: 'Status updated'
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_status')
      .to_return(status: 200, body: message.to_json, headers: {})

    InvoiceCancellationJob.perform_now

    @invoice.reload

    assert_equal('cancelled', @invoice.status)
    assert_equal('payment_not_received', @invoice.result.status)
  end

  def test_user_is_banned_if_exists
    message = {
      message: 'Status updated'
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_status')
      .to_return(status: 200, body: message.to_json, headers: {})

    payable = invoices(:payable)
    InvoiceCancellationJob.perform_now

    payable.reload
    assert_equal('cancelled', payable.status)
    assert_equal('payment_not_received', payable.result.status)

    assert(payable.user.banned?)
  end

  def test_paid_invoices_are_not_cancelled_automatically
    @invoice.mark_as_paid_at(Time.zone.now)
    InvoiceCancellationJob.perform_now

    @invoice.reload
    assert_equal('paid', @invoice.status)
  end
end
