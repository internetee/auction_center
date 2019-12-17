module ApplicationHealthCheck
  class Registry < OkComputer::Check
    include Concerns::HealthChecker

    def check
      if integration_disabled
        report_failure 'Registry integration disabled'
      else
        simple_check_endpoint(url: ::Registry::Base::BASE_URL,
                              no_url_message: 'No Registry url set',
                              fail_message: 'Cannot connect to Registry API',
                              success_message: 'Registry integration is up and running')
      end
    end

    def integration_disabled
      !AuctionCenter::Application.config.customization.dig('registry_integration', 'enabled')
    end
  end
end
