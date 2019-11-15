require 'test_helper'

class RegistryTest < ActiveSupport::TestCase
  def test_check
    checker = ApplicationHealthCheck::Registry.new
    checker.check

    assert(checker.message.present?)
  end
end
