require 'test_helper'

class Pages::Offers::EnglishAuctionOfferTable::ComponentTest < ViewComponent::TestCase
  def test_renders_english_auction_offer_table
    offer = offers(:high_offer)
    user = users(:participant)

    component = Pages::Offers::EnglishAuctionOfferTable::Component.new(offer: offer)
    component.define_singleton_method(:current_user) { user }

    render_inline(component)

    assert_includes rendered_content, offer.auction.domain_name
    assert_includes rendered_content, I18n.t('offers.overview')
    assert_selector 'th', text: I18n.t('auctions.domain_name')
    assert_selector 'th', text: I18n.t('auctions.ends_at')
    assert_selector 'th', text: I18n.t('offers.price')
    assert_selector '.offers-table-row', minimum: 1
  end
end
