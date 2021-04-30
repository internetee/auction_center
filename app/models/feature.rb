class Feature
  def self.registry_integration_enabled?
    !!AuctionCenter::Application.config
                                .customization[:registry_integration]
                                .compact.fetch(:enabled, true)

  end
end
