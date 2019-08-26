require 'test_helper'

class GoogleAnalyticsTest < ActiveSupport::TestCase
  def test_enabled_when_tracking_id_is_provided
    ga = GoogleAnalytics.new(tracking_id: 'any')
    assert ga.enabled?
  end

  def test_disabled_when_tracking_id_is_not_provided
    ga = GoogleAnalytics.new(tracking_id: '')
    assert_not ga.enabled?
  end
end
