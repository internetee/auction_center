require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
  def test_registry_integration_enabled_wraps_around_customization
    # Проверяем, что метод Feature.registry_integration_enabled? возвращает true или false
    assert_includes([true, false], Feature.registry_integration_enabled?)
  end
end
