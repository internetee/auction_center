require 'test_helper'
require 'messente/omnimessage'
require 'messente/sending_error'

class OmnimessageTest < ActiveSupport::TestCase
  def setup
    super

    @recipient = '+37250060070'
    @text = 'Your text sms'
  end

  def test_initialization_requires_recipent_text_and_channel
    instance = Messente::Omnimessage.new(@recipient, @text)

    assert_equal(@recipient, instance.recipient)
    assert_equal(@text, instance.text)
  end

  def test_server_url_is_a_constant
    assert_equal(URI('https://api.messente.com/v1/omnimessage'), Messente::Omnimessage::BASE_URL)
  end

  def test_username_and_password_are_constants
    assert_equal('messente_user', Messente::Omnimessage::USERNAME)
    assert_equal('messente_password', Messente::Omnimessage::PASSWORD)
    assert_equal('sms', Messente::Omnimessage::CHANNEL)
  end

  def test_request_is_an_http_post_request
    instance = Messente::Omnimessage.new(@recipient, @text)
    assert(instance.request.is_a?(Net::HTTP::Post))
  end

  def test_body_is_a_json_object
    instance = Messente::Omnimessage.new(@recipient, @text)
    expected_body = { to: @recipient, messages: [channel: 'sms', text: @text] }.to_json

    assert_equal(expected_body, instance.body)
  end

  def test_send_message_raises_an_error_when_answer_is_not_201
    instance = Messente::Omnimessage.new(@recipient, @text)

    body = {
      errors: [{
        code: '103',
        detail: 'Unauthorized',
        source: nil,
        title: 'Unauthorized',
      }],
    }

    response = Minitest::Mock.new
    response.expect(:code, '401')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_raises(Messente::SendingError) do
        instance.send_message
      end
    end
  end

  def test_send_message_returns_code_and_response_when_answer_is_201
    instance = Messente::Omnimessage.new(@recipient, @text)
    body = {
      messages: [{
        channel: 'sms',
        message_id: '02a632d6-9c7c-436e-8b9c-ea3ef636724c',
        sender: '+37255000002',
      }],
      omnimessage_id: '75cbf2b6-74e8-4c75-8093-f1041587cd04',
      to: '+37255000001',
    }

    response = Minitest::Mock.new
    response.expect(:code, '201')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      code, return_body = instance.send_message
      assert_equal(code, '201')
      assert_equal(body, return_body)
    end
  end
end
