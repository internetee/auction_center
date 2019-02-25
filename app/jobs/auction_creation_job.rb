class AuctionCreationJob < ApplicationJob
  def perform
    Registry::AuctionCreator.new.call
  end

  def self.needs_to_run?
    registry_integration_enabled?
  end

  def self.registry_integration_enabled?
    Feature.registry_integration_enabled?
  end
end
