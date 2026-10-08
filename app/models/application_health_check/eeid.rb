module ApplicationHealthCheck
  class Eeid < OkComputer::Check
    include HealthChecker

    def check
      issuer = AuctionCenter::Application.config.customization.dig(:eeid, :issuer)
      return mark_message('eeID is not configured') if issuer.blank?

      simple_check_endpoint(url: "#{issuer.chomp('/')}/.well-known/openid-configuration",
                            fail_message: 'eeID API is down',
                            success_message: 'eeID API is OK and running')
    end
  end
end
