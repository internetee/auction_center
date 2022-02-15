require 'test_helper'

class ResultCreationJobTest < ActiveJob::TestCase
  def setup
    super

    @auction_with_result = auctions(:expired)
    @auction_without_result = auctions(:valid_with_offers)

    if Feature.billing_system_integration_enabled?
      invoice_n = Invoice.order(number: :desc).last.number
      stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator")
        .to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}", headers: {})

      stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator")
        .to_return(status: 200, body: "{\"everypay_link\":\"http://link.test\"}", headers: {})

      stub_request(:put, "http://registry:3000/eis_billing/e_invoice_response").
        to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}, {\"date\":\"#{Time.zone.now-10.minutes}\"}", headers: {})

      stub_request(:post, "http://eis_billing_system:3000/api/v1/e_invoice/e_invoice").
        to_return(status: 200, body: "", headers: {})
    end
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
    mock = Minitest::Mock.new
    def mock.authorized; true; end

    clazz = EisBilling::BaseController.new

    clazz.stub :authorized, mock do
      assert_enqueued_with(job: InvoiceCreationJob) do
        ResultCreationJob.perform_now
      end
    end
  end
end
