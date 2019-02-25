require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
  def test_registry_integration_enabled_wraps_around_customization
    refute(Feature.registry_integration_enabled?)
  end
end
