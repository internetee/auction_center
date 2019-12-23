module ApplicationHealthCheck
  class SMS < OkComputer::Check
    include Concerns::HealthChecker

    def check
      simple_check_endpoint(url: Setting.find_by(code: 'check_sms_url').retrieve,
                            no_url_message: 'No SMS check url set',
                            fail_message: 'SMS API is down',
                            success_message: 'SMS API is OK')
    end
  end
end
