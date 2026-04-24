require 'test_helper'

class Common::Form::NumberField::ComponentTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_renders_number_field
    user = users(:participant)
    form = ActionView::Helpers::FormBuilder.new(:user, user, self, {})

    render_inline(Common::Form::NumberField::Component.new(form: form, attribute: :reference_no))

    assert_selector 'input[type="number"][name="user[reference_no]"][id="user_reference_no"]'
  end
end
