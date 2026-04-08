require 'test_helper'

class Common::Form::TelephoneField::ComponentTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_renders_telephone_field
    user = users(:participant)
    form = ActionView::Helpers::FormBuilder.new(:user, user, self, {})

    render_inline(Common::Form::TelephoneField::Component.new(form: form, attribute: :mobile_phone))

    assert_selector 'input[type="tel"][name="user[mobile_phone]"][id="user_mobile_phone"]'
  end
end
