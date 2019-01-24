require 'test_helper'

class InvoiceCancellationJobTest < ActiveJob::TestCase
  def setup
    super

    @invoice = invoices(:orphaned)
  end

  def test_overdue_invoices_are_cancelled_automatically
    InvoiceCancellationJob.perform_now

    @invoice.reload
    assert_equal('cancelled', @invoice.status)
  end

  def test_paid_invoices_are_not_cancelled_automatically
    @invoice.mark_as_paid_at(Time.zone.now)
    InvoiceCancellationJob.perform_now

    @invoice.reload
    assert_equal('paid', @invoice.status)
  end
end
