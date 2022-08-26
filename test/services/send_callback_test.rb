require 'test_helper'

class SendCallbackTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)

    @invoice = invoices(:payable)
    @reference_number = 'reference123'
  end

  def test_should_send_data_to_billing_directo
    incoming = {
      message: 'received'
    }

    stub_request(:get, "http://eis_billing_system:3000/api/v1/callback_handler/callback?payment_reference=#{@reference_number}")
      .to_return(status: 200, body: incoming.to_json, headers: {})

    response = EisBilling::SendCallback.send(reference_number: @reference_number)
    assert_equal response['message'], 'received'
  end
end
