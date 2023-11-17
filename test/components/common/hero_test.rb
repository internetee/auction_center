require "test_helper"

class HeroTest < ViewComponent::TestCase
  def test_render_component
    render_inline(Common::Hero::Component.new(title: 'Test', ))

    assert_selector 'h1.c-hero__content__title', text: 'Test'
  end
end