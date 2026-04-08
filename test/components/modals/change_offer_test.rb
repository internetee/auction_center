require 'test_helper'

class Modals::ChangeOffer::ComponentTest < ViewComponent::TestCase
  include Devise::Test::IntegrationHelpers

  def test_renders_change_offer_modal
    user = users(:participant)
    auction = auctions(:english)
    billing_profile = billing_profiles(:private_person)

    offer = Offer.new(user: user, auction: auction, billing_profile: billing_profile, cents: 500)
    autobider = Autobider.new(user: user, domain_name: auction.domain_name, cents: 1000, enable: false)

    render_inline(Modals::ChangeOffer::Component.new(
      offer: offer,
      auction: auction,
      autobider: autobider,
      update: false,
      current_user: user,
      captcha_required: false,
      show_checkbox_recaptcha: false
    ))

    assert_selector '.c-modal-overlay'
    assert_includes rendered_content, auction.domain_name
    assert_selector 'form#english_offer_form'
  end
end
