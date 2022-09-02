require 'test_helper'

class GetInvoiceNumberTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    @invoice = invoices(:payable)
  end

  def test_should_send_data_to_billing_directo
    message = {
      message: '12345'
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator')
      .to_return(status: 200, body: message.to_json, headers: {})

    response = EisBilling::GetInvoiceNumber.call
    assert_equal response['message'], '12345'
  end
end
