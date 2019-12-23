module ApplicationHealthCheck
  class API < OkComputer::Check
    include Concerns::HealthChecker
    def check
      simple_check_endpoint(url: Setting.find_by(code: 'check_api_url').retrieve,
                            no_url_message: 'No API check url set',
                            fail_message: 'API is down',
                            success_message: 'API is up and OK')
    end
  end
end
