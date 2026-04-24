require 'test_helper'

class Modals::Deposit::ComponentTest < ViewComponent::TestCase
  def test_renders_deposit_modal
    user = users(:participant)
    auction = auctions(:deposit_english)

    render_inline(Modals::Deposit::Component.new(
      auction: auction,
      current_user: user,
      captcha_required: false,
      show_checkbox_recaptcha: false
    ))

    assert_selector '#deposit4-v2.c-modal-overlay'
    assert_includes rendered_content, auction.domain_name
    assert_selector 'form'
  end
end
