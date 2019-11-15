require 'test_helper'

class ApiTest < ActiveSupport::TestCase
  include Concerns::HttpRequester

  def test_check
    checker = ApplicationHealthCheck::API.new
    checker.check

    assert(checker.message.present?)
  end
end
