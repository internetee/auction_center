class DomainRegistrationCheckJob < ApplicationJob
  def perform
    Result.pending_registration.map do |result|
      DomainRegistrationChecker.new(result).call
    end
  end

  def self.needs_to_run?
    registry_integration_enabled? && Result.pending_registration.any?
  end

  def self.registry_integration_enabled?
    AuctionCenter::Application.config
                              .customization
                              .dig('registry_integration', 'enabled')
  end
end
