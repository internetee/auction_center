class AuctionCreationJob < ApplicationJob
  def perform
    Registry::AuctionCreator.new.call
  end

  def self.needs_to_run?
    registry_integration_enabled?
  end

  def self.registry_integration_enabled?
    AuctionCenter::Application.config
                              .customization
                              .dig('registry_integration', 'enabled')
  end
end
