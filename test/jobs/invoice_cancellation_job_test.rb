require 'test_helper'

class InvoiceCancellationJobTest < ActiveJob::TestCase
  def setup
    super

    @invoice = invoices(:orphaned)
  end

  def test_overdue_invoices_are_canceled_automatically
    InvoiceCancellationJob.perform_now

    @invoice.reload
    assert_equal('cancelled', @invoice.status)
  end
end
