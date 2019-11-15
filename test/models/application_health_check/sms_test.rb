require 'test_helper'

class SMSTest < ActiveSupport::TestCase
  def test_check
    checker = ApplicationHealthCheck::SMS.new
    checker.check

    assert(checker.message.present?)
  end
end
