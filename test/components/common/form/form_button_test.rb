require "test_helper"

class FormButtonTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_render_component
    @session = {}
    form = ActionView::Helpers::FormBuilder.new(:session, @session, self, {})

    render_inline(Common::Form::FormButton::Component.new(
      form: form, btn_title: I18n.t(:sign_in), data_turbo: false
    ))

    assert_selector 'button.c-btn.c-btn--green.c-login__btn[type="submit"][name="button"][data-turbo="false"]', text: 'Sign in'
  end
end