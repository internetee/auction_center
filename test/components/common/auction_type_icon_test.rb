require "test_helper"

class AuctionTypeIconTest < ViewComponent::TestCase
  def test_render_component
    @auction = auctions(:valid_with_offers)
    @auction.update(platform: "blind") && @auction.reload
    
    assert @auction.blind?

    render_inline(Common::AuctionTypeIcon::Component.new(auction: @auction))
    assert_text("PO")

    @english = auctions(:english)

    render_inline(Common::AuctionTypeIcon::Component.new(auction: @english))
    assert_text("IO")
  end
end
