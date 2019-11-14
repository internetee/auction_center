module ApplicationHealthCheck
  class Registry < OkComputer::Check
    include Concerns::HealthChecker

    def check
      report_failure 'Registry integration disabled' unless integration_enabled

      simple_check_endpoint(url: ::Registry::Base::BASE_URL,
                            no_url_message: 'No Registry url set',
                            fail_message: 'Cannot connect to Registry API',
                            success_message: 'Registry integration is up and running')
    end

    def integration_enabled
      AuctionCenter::Application.config.customization.dig('registry_integration', 'enabled')
    end
  end
end
