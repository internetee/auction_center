require "test_helper"

class CheckboxTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_render_component
    model = User.new

    form = ActionView::Helpers::FormBuilder.new(:user, model, self, {})

    render_inline(Common::Form::Checkbox::Component.new(
      label_title: 'First name',
      form: form,
      attribute: :given_names
    ))

    assert_selector 'label.o-checkbox-container.c-login__checkbox-container'
    assert_selector 'label .o-checkbox-text', text: 'First name'
    assert_selector 'label input[type="hidden"][name="user[given_names]"][value="0"]', visible: false
    assert_selector 'label input.o-checkbox-sample[type="checkbox"][value="1"][name="user[given_names]"]'
    assert_selector 'label input[type="checkbox"][id="user_given_names"]'
    assert_selector 'label .o-checkmark-sample'
  end
end
