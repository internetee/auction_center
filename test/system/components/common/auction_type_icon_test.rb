require "test_helper"

class AuctionTypeIconTest < ViewComponent::TestCase
  def test_render_component
    # render_inline(ExampleComponent.new(title: "my title")) { "Hello, World!" }

    # assert_selector("span[title='my title']", text: "Hello, World!")
    # or, to just assert against the text:
    # assert_text("Hello, World!")

    @auction = auctions(:valid_with_offers)

    # render_inline(Comon::AuctionTypeIcon::Component.new(auction: @auction) do
      
    # end
  end
end
