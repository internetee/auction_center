require "test_helper"

class EmailFieldTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_render_component
    @user = users(:participant)
    form = ActionView::Helpers::FormBuilder.new(:user, @user, self, {})

    render_inline(Common::Form::EmailField::Component.new(
      form: form, attribute: :email, 
      options: { autocomplete: 'email', autofocus: true, label_caption: I18n.t('users.email') }
    ))

    assert_selector 'input#user_email[type="email"][autofocus="autofocus"][name="user[email]"][value="user@auction.test"]'
  end
end