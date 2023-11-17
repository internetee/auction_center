require "test_helper"

class PasswordFieldTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_render_component
    @user = users(:participant)
    form = ActionView::Helpers::FormBuilder.new(:user, @user, self, {})

    render_inline(Common::Form::PasswordField::Component.new(
      form: form, attribute: :password, 
      options: { autocomplete: 'password', autofocus: true, label_caption: I18n.t('users.password') }
    ))

    assert_selector 'label', text: 'Password'
    assert_selector 'input[type="password"][autofocus="autofocus"][name="user[password]"][id="user_password"]'  
  end
end