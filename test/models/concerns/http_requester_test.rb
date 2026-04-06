require 'test_helper'

class HttpRequesterTest < ActiveSupport::TestCase
  class Dummy
    include HttpRequester
  end

  def test_success_result_parses_json_and_status
    response = Object.new
    response.define_singleton_method(:read_body) { '{"ok":true}' }
    response.define_singleton_method(:code) { '200' }

    result = Dummy.new.success_result(response: response)

    assert_equal({ 'ok' => true }, result[:body])
    assert_equal 200, result[:status]
  end

  def test_default_post_request_response_returns_success_and_sets_json_body
    url = URI('https://example.test/path')
    body = { foo: 'bar' }
    t = self

    response = Object.new
    response.define_singleton_method(:read_body) { '{"ok":true}' }
    response.define_singleton_method(:code) { '200' }

    http_double = Object.new
    http_double.define_singleton_method(:use_ssl=) { |_val| true }
    http_double.define_singleton_method(:request) do |request|
      t.assert_kind_of Net::HTTP::Post, request
      t.assert_equal body.to_json, request.body
      response
    end

    Net::HTTP.stub(:new, http_double) do
      result = Dummy.new.default_post_request_response(url: url, body: body, headers: { 'Content-Type' => 'application/json' })
      assert_equal({ 'ok' => true }, result[:body])
      assert_equal 200, result[:status]
    end
  end

  def test_default_get_request_response_returns_success
    url = URI('https://example.test/path')
    t = self

    response = Object.new
    response.define_singleton_method(:read_body) { '{"ok":true}' }
    response.define_singleton_method(:code) { '200' }

    http_double = Object.new
    http_double.define_singleton_method(:use_ssl=) { |_val| true }
    http_double.define_singleton_method(:request) do |request|
      t.assert_kind_of Net::HTTP::Get, request
      response
    end

    Net::HTTP.stub(:new, http_double) do
      result = Dummy.new.default_get_request_response(url: url, headers: nil, body: nil)
      assert_equal({ 'ok' => true }, result[:body])
      assert_equal 200, result[:status]
    end
  end

  def test_default_get_request_response_returns_failed_result_on_http_errors
    url = URI('https://example.test')

    [Timeout::Error.new('timeout'), EOFError.new, Errno::ECONNRESET.new].each do |error|
      Net::HTTP.stub(:new, ->(*) { raise error }) do
        result = Dummy.new.default_get_request_response(url: url, headers: nil, body: nil)
        assert_equal 503, result[:status]
        assert_includes result[:body], 'Error occured'
      end
    end
  end
end
