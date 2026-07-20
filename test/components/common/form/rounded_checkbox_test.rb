require 'test_helper'

class Common::Form::Checkboxes::RoundedCheckbox::ComponentTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_renders_rounded_checkbox
    user = users(:participant)
    form = ActionView::Helpers::FormBuilder.new(:user, user, self, {})

    render_inline(Common::Form::Checkboxes::RoundedCheckbox::Component.new(form: form, attribute: :terms_and_conditions_accepted_at))

    assert_selector 'label.o-checkbox'
    assert_selector 'input[type="checkbox"][name="user[terms_and_conditions_accepted_at]"]'
    assert_selector '.o-checkbox__slider.round'
  end
end
