require "test_helper"

class DropdownInputTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper

  def test_render_component
    @invoice = invoices(:payable)
    form = ActionView::Helpers::FormBuilder.new(:invoice, @invoice, self, {})

    render_inline(Common::Form::DropdownInput::Component.new(
      form: form, attribute: :billing_profile_id, 
      enum: options_for_select(BillingProfile.where(user_id: @invoice.user_id).pluck(:name, :id), @invoice.billing_profile_id),
      label: I18n.t('billing_profiles_name')
    ))

    assert_selector 'label', text: 'Billing Profiles'
    assert_selector 'select#invoice_billing_profile_id[name="invoice[billing_profile_id]"]'

    assert_selector 'select#invoice_billing_profile_id option[value="435320743"]', text: 'Joe John Participant'
    assert_selector 'select#invoice_billing_profile_id option[value="264178000"][selected="selected"]', text: 'ACME Inc.'
    assert_selector 'select#invoice_billing_profile_id option[value="338446587"]', text: 'Unused Profile'
  end
end