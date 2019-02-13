module Registry
  class Base
    HTTP_SUCCESS = '200'
    BASE_URL = URI(AuctionCenter::Application.config.customization.dig('registry_integration',
                                                                       'url'))

    attr_reader :body_as_string
    attr_reader :code_as_string
    attr_reader :response

    def perform_request(request)
      @response = Net::HTTP.start(BASE_URL.host, BASE_URL.port) do |http|
        http.request(request)
      end

      @body_as_string = response.body
      @code_as_string = response.code.to_s

      if code_as_string != HTTP_SUCCESS
        raise CommunicationError.new(request, body_as_string, code_as_string)
      end
    end
  end
end
