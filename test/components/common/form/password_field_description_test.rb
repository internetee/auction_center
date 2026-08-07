require 'test_helper'

class Common::Form::PasswordField::Description::ComponentTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_renders_password_description_label
    user = users(:participant)
    form = ActionView::Helpers::FormBuilder.new(:user, user, self, {})

    render_inline(Common::Form::PasswordField::Description::Component.new(
      form: form,
      attribute: :password,
      minimum_password_length: 8,
      user: user
    ))

    assert_selector 'label.c-account__label-explain'
    assert_includes rendered_content, 'password'
    assert_includes rendered_content, '8'
  end
end
