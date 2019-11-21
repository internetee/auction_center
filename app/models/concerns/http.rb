require 'net/http'
require 'uri'
require 'json'

# Model to communicate with API's
class Http
  def self.get(path, params)
    request :get, path, params
  end

  def self.post(path, params)
    request :post, path, params
  end

  def self.put(path, params)
    request :put, path, params
  end

  def self.delete(path, params)
    request :delete, path, params
  end

  def self.request(method, path, params = {})
    uri = URI.parse(path)
    headers = { 'Content-Type' => 'application/json' }
    http = Net::HTTP.new(uri.host, uri.port)

    if path.starts_with? 'https://'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = http_method[method.to_sym].new(uri.request_uri, headers)
    request.body = params.to_json

    http.request(request)
  end

  def self.http_method
    {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      put: Net::HTTP::Put,
      delete: Net::HTTP::Delete,
    }
  end
end
