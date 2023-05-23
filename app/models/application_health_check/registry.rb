module ApplicationHealthCheck
  class Registry < OkComputer::Check
    include HealthChecker

    def check
      if integration_disabled?
        report_failure 'Registry integration disabled'
      else
        simple_check_endpoint(url: ::Registry::Base::BASE_URL,
                              fail_message: 'Cannot connect to Registry API',
                              success_message: 'Registry integration is up and running')
      end
    end

    def integration_disabled?
      !Feature.registry_integration_enabled?
    end
  end
end
