require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    @invoice = invoices(:payable)

    @everypay_link = {
      everypay_link: 'http://link.test'
    }
  end

  def test_should_send_data_to_billing_directo
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator')
      .to_return(status: 200, body: @everypay_link.to_json, headers: {})

    requier = EisBilling::Invoice.new(@invoice)
    response = requier.send_invoice
    assert_equal response['everypay_link'], 'http://link.test'
  end
end
