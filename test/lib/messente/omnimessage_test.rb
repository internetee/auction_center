require 'test_helper'
require 'messente/omnimessage'

class OmnimessageTest < ActiveSupport::TestCase
  def setup
    super

    @channel = 'sms'
    @recipient = '+37250060070'
    @text = 'Your text sms'
  end


  def test_initialization_requires_recipent_text_and_channel
    instance = Messente::Omnimessage.new(@channel, @recipient, @text)

    assert_equal(@channel, instance.channel)
    assert_equal(@recipient, instance.recipient)
    assert_equal(@text, instance.text)
  end

  def test_server_url_is_a_constant
    assert_equal(URI('https://api.messente.com/v1/omnimessage'), Messente::Omnimessage::BASE_URL)
  end

  def test_username_and_password_are_constants
    assert_equal('messente_user', Messente::Omnimessage::USERNAME)
    assert_equal('messente_password', Messente::Omnimessage::PASSWORD)
  end

  def test_request_is_an_http_post_request
    instance = Messente::Omnimessage.new(@channel, @recipient, @text)
    assert(instance.request.is_a?(Net::HTTP::Post))
  end

  def test_body_is_a_json_object
    instance = Messente::Omnimessage.new(@channel, @recipient, @text)
    expected_body = { to: @recipient, messages: [channel: @channel, text: @text]}.to_json

    assert_equal(expected_body, instance.body)
  end

  def test_send_message
    instance = Messente::Omnimessage.new(@channel, @recipient, @text)
  end
end
