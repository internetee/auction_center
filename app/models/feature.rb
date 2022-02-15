class Feature
  def self.registry_integration_enabled?
    !!AuctionCenter::Application.config
                                .customization[:registry_integration]
                                &.compact&.fetch(:enabled, true)

  end

  def self.billing_system_integration_enabled?
    !!AuctionCenter::Application.config
                                .customization[:billing_system_integration]
                                &.compact&.fetch(:enabled, false)

  end
end
