class AvilabilityCheckerService
  BASE_URL = AuctionCenter::Application.config.customization.dig(:registry_integration, :url)

  attr_reader :domain_name

  def initialize(domain_name:)
    @domain_name = domain_name
  end

  def self.call(domain_name:)
    request_handler = new(domain_name: domain_name)
    res = request_handler.fetch_result

    request_handler.parse_response(res)
  end

  def fetch_result
    url = "#{BASE_URL}avilability_check?domain_name=#{domain_name}"
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true unless Rails.env.development? || Rails.env.test?
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?

    response = http.get(url)

    response.body
  end

  def parse_response(data)
    parsed_data = JSON.parse(data)['body'][0]
    availabe = parsed_data['avail']

    return false if availabe == 1

    true
  end
end
