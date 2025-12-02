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

  def self.open_ai_integration_enabled?
    !!AuctionCenter::Application.config.customization[:openai]
                                &.compact&.fetch(:enabled, false)
  end

  def self.mobile_api_enabled?
    !!AuctionCenter::Application.config.customization[:mobile_api]
                                &.compact&.fetch(:enabled, false)
  end

  def self.minimum_mobile_version
    AuctionCenter::Application.config.customization[:mobile_api]
                              &.compact&.fetch(:minimum_version, '1.0.0')
  end
end
