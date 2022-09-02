require 'test_helper'

class OneoffTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    @invoice = invoices(:payable)
  end

  def test_should_send_data_to_billing_directo
    message = {
      message: 'ok'
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/oneoff')
      .to_return(status: 200, body: message.to_json, headers: {})
    response = EisBilling::Oneoff.send_invoice(invoice_number: @invoice.number.to_s, customer_url: 'eeid.test ')

    assert_equal response['message'], 'ok'
  end
end
