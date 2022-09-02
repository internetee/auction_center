require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    @invoice = invoices(:payable)
    @mock_instance = Class.new do
      include EisBilling::Request
    end.new
  end

  def test_get_request
    endpoint = 'http://eis_billing_system:3000/get_me_something'
    response = {
      message: 'here you are'
    }

    stub_request(:get, 'http://eis_billing_system:3000/get_me_something')
      .to_return(status: 200, body: response.to_json, headers: {})

    res = @mock_instance.get(endpoint)
    assert_equal res['message'], 'here you are'
  end

  def test_post_request
    endpoint = 'http://eis_billing_system:3000/get_me_something'
    response = {
      message: 'I got it'
    }
    payload = {
      object: 'superobject'
    }

    stub_request(:post, 'http://eis_billing_system:3000/get_me_something')
      .to_return(status: 200, body: response.to_json, headers: {})

    res = @mock_instance.post(endpoint, payload)
    assert_equal res['message'], 'I got it'
  end
end
