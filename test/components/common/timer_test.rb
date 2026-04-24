require 'test_helper'

class Common::Timer::ComponentTest < ViewComponent::TestCase
  def test_renders_countdown_attributes
    render_inline(Common::Timer::Component.new(auction: auctions(:valid_with_offers)))

    assert_selector 'span[data-controller="countdown"]'
    assert_selector 'span[data-countdown-refresh-interval-value="500"]'
    assert_selector 'span[data-countdown-date-value]'
  end
end
