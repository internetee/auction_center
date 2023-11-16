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
      for_component: 'user_email',
      options: { style: 'custom-style', css_class: 'extra-class' },
      data_attributes: { custom_data: 'value' }
    ))

    assert_selector 'label[for="user_email"].extra-class[style="custom-style"][data-custom-data="value"]', text: 'Email'
  end
end