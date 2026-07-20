require 'test_helper'

class Modals::ChangeOfferPo::ComponentTest < ViewComponent::TestCase
  def test_renders_change_offer_po_modal
    user = users(:participant)
    offer = offers(:high_offer)
    auction = offer.auction

    render_inline(Modals::ChangeOfferPo::Component.new(
      offer: offer,
      auction: auction,
      update: true,
      current_user: user,
      captcha_required: false,
      show_checkbox_recaptcha: false
    ))

    assert_selector '.c-modal-overlay'
    assert_includes rendered_content, auction.domain_name
    assert_selector 'form#english_offer_form'
  end
end
