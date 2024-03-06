require "test_helper"

class LabelTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_label_without_content
    @user = users(:participant)
    @form = ActionView::Helpers::FormBuilder.new(:user, @user, self, {})

    render_inline(Common::Form::Label::Component.new(
      attribute: :email, 
      form: @form, 
      title: 'Email', 
      options: { style: 'custom-style', class: 'extra-class' },
    ))

    assert_selector 'label[for="user_email"].extra-class[style="custom-style"]', text: 'Email'
  end
end