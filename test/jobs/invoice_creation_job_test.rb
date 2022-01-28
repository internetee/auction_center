require 'test_helper'

class InvoiceCreationJobTest < ActiveJob::TestCase
  def setup
    super

    @result_that_was_sold = results(:expired_participant)
    @result_that_was_not_sold = results(:without_offers_nobody)
  end

  def teardown
    super

    WebMock.reset!
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def test_job_generates_invoice_for_results_that_need_them
    InvoiceCreationJob.perform_now

    assert(invoice = @result_that_was_sold.invoice)
    assert_nil(@result_that_was_not_sold.invoice)

    assert_equal('issued', invoice.status)
  end
end
