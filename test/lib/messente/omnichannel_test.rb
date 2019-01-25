require 'test_helper'
require 'messente/omnichannel'

class OmnichannelTest < ActiveSupport::TestCase
  def setup
    super

    @channel = 'sms'
    @recipient = '+37250060070'
    @text = 'Your text sms'
  end


  def test_initialization_requires_recipent_text_and_channel
    instance = Messente::Omnichannel.new(@channel, @recipient, @text)

    assert_equal(@channel, instance.channel)
    assert_equal(@recipient, instance.recipient)
    assert_equal(@text, instance.text)
  end

  def test_server_url_is_a_constant
    assert_equal('api.messente.com', Messente::Omnichannel::BASE_URI)
    assert_equal(443, Messente::Omnichannel::SSL_PORT)
  end

  def test_username_and_password_are_constants
    assert_equal('messente_user', Messente::Omnichannel::USERNAME)
    assert_equal('messente_password', Messente::Omnichannel::PASSWORD)
  end

  def test_request_is_an_https_request
    instance = Messente::Omnichannel.new(@channel, @recipient, @text)
    assert(instance.request.is_a?(Net::HTTP))
  end
end
