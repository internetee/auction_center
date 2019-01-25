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

  def test_username_and_password_are_constants
    assert_equal('messente_user', Messente::Omnichannel::USERNAME)
    assert_equal('messente_password', Messente::Omnichannel::PASSWORD)
  end
end
