require 'test_helper'

class ResultCreationJobTest < ActiveJob::TestCase
  def setup
    super

    @auction_with_result = auctions(:expired)
    @auction_without_result = auctions(:valid_with_offers)
  end

  def teardown
    super
  end

  def test_job_creates_results_for_auctions_that_need_it
    original_result = @auction_with_result.result
    ResultCreationJob.perform_now

    @auction_with_result.reload
    @auction_without_result.reload

    assert_equal(original_result, @auction_with_result.result)

    assert(result = @auction_without_result.result)
    assert_equal(true, result.awaiting_payment?)
  end

  def test_job_schedules_invoice_creation
    assert_enqueued_with(job: InvoiceCreationJob) do
      ResultCreationJob.perform_now
    end
  end
end
