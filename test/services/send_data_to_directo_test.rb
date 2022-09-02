require 'test_helper'

class SendDataToDirectoTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
  end

  def test_should_send_data_to_billing_directo
    object_data = {
      invoice_number: '12345',
      status: 'paid',
      transaction_time: Time.zone.now,
      some_field: 'hello'
    }

    response_data = {
      message: 'hello',
    }

    stub_request(:post, 'http://eis_billing_system:3000/api/v1/directo/directo')
      .to_return(status: 200, body: response_data.to_json, headers: {})

    res = EisBilling::SendDataToDirecto.send_request(object_data: [object_data.to_json])
    assert_equal res['message'], 'hello'
  end
end
