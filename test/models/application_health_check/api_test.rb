require 'test_helper'

class ApiTest < ActiveSupport::TestCase
  include Concerns::HttpRequester

  def test_check
    checker = ApplicationHealthCheck::API.new
    checker.check

    assert(checker.message.present?)
  end

  def test_returns_error_on_timeout
    setting = settings(:check_api_url)
    setting.update!(value: 'http://example.com:61')
    checker = ApplicationHealthCheck::API.new
    checker.check
    assert_not(checker.success?)
  end
end
