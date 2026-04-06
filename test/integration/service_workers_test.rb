require 'test_helper'

class ServiceWorkersTest < ActionDispatch::IntegrationTest
  def test_service_worker_js_is_served_with_expected_headers
    get '/service-worker.js'

    assert_response :ok
    assert_match(/javascript/, response.headers['Content-Type'])
    assert_includes response.body, 'self.addEventListener'
  end

  def test_manifest_json_is_served_with_expected_headers
    get '/manifest.json'

    assert_response :ok
    assert_equal 'application/json', response.headers['Content-Type']
    assert_includes response.body, '"short_name"'
  end
end
