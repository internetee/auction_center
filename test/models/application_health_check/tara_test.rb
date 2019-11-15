require 'test_helper'

class TaraTest < ActiveSupport::TestCase
  def test_check
    checker = ApplicationHealthCheck::Tara.new
    checker.check

    assert(checker.message.present?)
  end
end
