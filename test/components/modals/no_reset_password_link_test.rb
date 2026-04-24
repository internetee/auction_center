require 'test_helper'

class Modals::NoResetPasswordLink::ComponentTest < ViewComponent::TestCase
  def test_renders_no_reset_password_link_modal
    render_inline(Modals::NoResetPasswordLink::Component.new(resource: User.new, resource_name: :user))

    assert_selector '.c-modal-overlay.c-modal--fp.c-modal--vi.js-modal'
    assert_selector 'form.c-modal__main'
    assert_selector 'input[type="email"]'
    assert_selector 'button[type="submit"].c-btn.c-btn--blue.c-fp__btn', text: I18n.t(:submit)
    assert_selector 'a.c-login__remind-link', text: I18n.t('devise.shared.links.log_in')
    assert_includes rendered_content, I18n.t('profile')
    assert_includes rendered_content, I18n.t('devise.confirmations.new.title')
  end
end
