require 'test_helper'

class BulkInvoicesTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    @invoice = invoices(:payable)
    @invoice_two = invoices(:orphaned)

    @everypay_link = {
      everypay_link: 'http://link.test'
    }
  end

  def test_sum_invoices_calculation
    bulk = EisBilling::BulkInvoicesService.new([@invoice, @invoice_two])
    total = bulk.send :total_transaction_amount, [@invoice, @invoice_two]

    assert_equal total, (@invoice.total.to_f + @invoice_two.total.to_f).to_s
  end

  def test_should_send_bulk_invoices
    invoice_n = Invoice.order(number: :desc).last.number
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator')
      .to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}", headers: {})
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator')
      .to_return(status: 200, body: '{"everypay_link":"http://link.test"}', headers: {})

    result = EisBilling::BulkInvoicesService.call([@invoice, @invoice_two])

    assert_equal result.instance['everypay_link'], 'http://link.test'
  end
end
