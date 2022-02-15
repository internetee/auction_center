require 'test_helper'

class InvoiceCreationJobTest < ActiveJob::TestCase
  def setup
    super

    @result_that_was_sold = results(:expired_participant)
    @result_that_was_not_sold = results(:without_offers_nobody)

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

  def test_job_generates_invoice_for_results_that_need_them
    mock = Minitest::Mock.new
    def mock.authorized; true; end

    clazz = EisBilling::BaseController.new

    clazz.stub :authorized, mock do
      InvoiceCreationJob.perform_now

      assert(invoice = @result_that_was_sold.invoice)
      assert_nil(@result_that_was_not_sold.invoice)

      assert_equal('issued', invoice.status)
    end
  end
end
