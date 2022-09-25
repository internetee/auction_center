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
    bulk = EisBilling::BulkInvoices.new([@invoice, @invoice_two])
    assert_equal bulk.total_transaction_amount([@invoice, @invoice_two]), (@invoice.total.to_f + @invoice_two.total.to_f).to_s
  end
end