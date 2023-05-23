module ApplicationHealthCheck
  class Sms < OkComputer::Check
    include HealthChecker

    def check
      simple_check_endpoint(url: Setting.find_by(code: 'check_sms_url').retrieve,
                            fail_message: 'SMS API is down',
                            success_message: 'SMS API is OK')
    end
  end
end
