class Feature
  def self.registry_integration_enabled?
    AuctionCenter::Application.config
                              .customization
                              .dig('registry_integration', 'enabled')
  end
end
