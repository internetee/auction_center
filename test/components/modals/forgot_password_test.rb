require 'test_helper'

class Modals::ForgotPassword::ComponentTest < ViewComponent::TestCase
  def test_renders_forgot_password_modal
    render_inline(Modals::ForgotPassword::Component.new(resource: User.new, resource_name: :user))

    assert_selector '.c-modal-overlay.c-modal--fp'
    assert_selector 'form.c-fp__form'
    assert_selector 'input[type="email"]'
    assert_selector 'button[type="submit"].c-btn.c-btn--blue.c-fp__btn', text: I18n.t('devise.passwords.new.reset_button')
    assert_selector 'a.c-login__remind-link', text: I18n.t('devise.shared.links.log_in')
    assert_selector 'a.c-login__remind-link', text: I18n.t('devise.shared.links.didnt_receive_confirmation_instructions')
    assert_includes rendered_content, I18n.t('profile')
    assert_includes rendered_content, I18n.t(:forgot_your_password)
  end
end
