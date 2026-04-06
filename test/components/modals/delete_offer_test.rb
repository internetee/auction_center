require 'test_helper'

class Modals::DeleteOffer::ComponentTest < ViewComponent::TestCase
  def test_renders_delete_offer_modal
    offer = offers(:high_offer)

    render_inline(Modals::DeleteOffer::Component.new(offer: offer))

    assert_selector '.c-modal-overlay.js-modal-delete'
    assert_includes rendered_content, offer.auction.domain_name
    assert_selector 'form'
  end
end
