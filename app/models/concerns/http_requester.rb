module Concerns
  module HttpRequester
    extend ActiveSupport::Concern

    HTTP_METHODS = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
    }.freeze

    def default_request_response(url:, body:, headers:, type: :post)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (url.scheme == 'https')
      request = HTTP_METHODS[type].new(uri.request_uri)
      headers&.each { |key, val| request[key] = val }
      request.body = body.to_json if body
      success_result(response: http.request(request))
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError, Errno::EADDRNOTAVAIL
      failed_result
    end

    def success_result(response:)
      {
        body: JSON.parse(response.read_body),
        status: response.code.to_i,
      }
    end

    def failed_result
      error_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[:service_unavailable]
      {
        body: 'Error occured',
        status: error_code,
      }
    end

    def default_post_request_response(url:, body: nil, headers: nil)
      default_request_response(url: url, body: body, headers: headers, type: :post)
    end

    def default_get_request_response(url:, body: nil, headers: nil)
      default_request_response(url: url, body: body, headers: headers, type: :get)
    end
  end
end
