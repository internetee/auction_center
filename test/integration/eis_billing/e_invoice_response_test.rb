require 'test_helper'

class EInvoiceResponseTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:participant)
    @invoice = invoices(:payable)
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)

    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
      .to_return(status: 200, body: @message.to_json, headers: {})
  end

  def test_invoice_should_be_mark_as_sent
    assert_nil @invoice.e_invoice_sent_at
    put eis_billing_e_invoice_response_path, params: { invoice_number: @invoice.number }

    @invoice.reload
    assert_not_nil @invoice.e_invoice_sent_at
  end
end
