module ApplicationHealthCheck
  class Tara < OkComputer::Check
    include Concerns::HealthChecker

    def check
      simple_check_endpoint(url: Setting.check_tara_url,
                            no_url_message: 'Tara check URL is not set',
                            fail_message: 'Tara API is down',
                            success_message: 'Tara API is OK and running')
    end
  end
end
