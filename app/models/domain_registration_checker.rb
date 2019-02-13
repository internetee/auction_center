class DomainRegistrationChecker
  BASE_URL = URI('http://registry:3000/api/v1/auctions/')
  HTTP_SUCCESS = '200'

  attr_reader :result

  def initialize(result)
    @result = result
  end

  def call
    #
  end

  def request
    @request ||= Net::HTTP::Get.new(
      URI.join(BASE_URL, remote_id),
      { 'Content-Type': 'application/json' }
    )
  end

  private

  def remote_id
    result.auction.remote_id
  end
end
