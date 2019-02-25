class DomainRegistrationCheckJob < ApplicationJob
  def perform
    Result.pending_registration.map do |result|
      Registry::RegistrationChecker.new(result).call
    end
  end

  def self.needs_to_run?
    registry_integration_enabled? && Result.pending_registration.any?
  end

  def self.registry_integration_enabled?
    Feature.registry_integration_enabled?
  end
end
