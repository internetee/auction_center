class DomainRegistrationCheckJob < ApplicationJob
  def perform
    Result.pending_registration.map do |result|
      begin
        Registry::RegistrationChecker.new(result).call
      rescue Registry::CommunicationError => e
        Airbrake.notify(e)
        next
      end
    end
  end

  def self.needs_to_run?
    registry_integration_enabled? && Result.pending_registration.any?
  end

  def self.registry_integration_enabled?
    Feature.registry_integration_enabled?
  end
end
