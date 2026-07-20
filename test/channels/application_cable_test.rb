require 'test_helper'

class ApplicationCableTest < ActiveSupport::TestCase
  def test_channel_base_class
    assert ApplicationCable::Channel < ActionCable::Channel::Base
  end

  def test_connection_base_class
    assert ApplicationCable::Connection < ActionCable::Connection::Base
  end
end
