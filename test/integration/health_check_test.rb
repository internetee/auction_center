require 'test_helper'

class HealthCheckTest < ActionDispatch::IntegrationTest

  def test_default_check_passed
    get("/healthcheck/default", as: :json)

    keys = parse_keys(response: response, endpoint: 'default')

    assert_health_check_keys(keys)
  end

  def test_db_check_passed
    get('/healthcheck/database', as: :json)

    keys = parse_keys(response: response, endpoint: 'database')

    assert_health_check_keys(keys)
  end

  def test_api_check_passed
    get('/healthcheck/api', as: :json)

    keys = parse_keys(response: response, endpoint: 'api')

    assert_health_check_keys(keys)
  end

  def test_registry_check_passed
    get('/healthcheck/registry', as: :json)

    keys = parse_keys(response: response, endpoint: 'registry')

    assert_health_check_keys(keys)
  end

  def test_tara_check_passed
    get('/healthcheck/tara', as: :json)

    keys = parse_keys(response: response, endpoint: 'tara')

    assert_health_check_keys(keys)
  end

  def test_email_check_passed
    get('/healthcheck/email', as: :json)

    keys = parse_keys(response: response, endpoint: 'email')

    assert_health_check_keys(keys)
  end

  def test_sms_check_passed
    get('/healthcheck/sms', as: :json)

    keys = parse_keys(response: response, endpoint: 'sms')

    assert_health_check_keys(keys)
  end

  def parse_keys(response:, endpoint:)
    response_json = JSON.parse(response.body)
    response_json[endpoint].keys
  end

  def assert_health_check_keys(keys)
    assert_includes(keys, 'message')
    assert_includes(keys, 'success')
    assert_includes(keys, 'time')
  end
end
