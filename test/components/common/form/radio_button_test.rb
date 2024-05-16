require "test_helper"

class Common::Form::RadioButton::ComponentTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_render_component
    form = ActionView::Helpers::FormBuilder.new(route.auctions_path, nil, self, { })

    render_inline(Common::Form::RadioButton::Component.new(
      form: form, title: 'blind', attribute: :type, 
      data_attributes: { }, options: { style: 'visibility: hidden; position: absolute;', id: 'filter_PO_button'}
    ))

    assert_selector 'input.js-table-filter-btn[type="radio"][id="filter_PO_button"][value="blind"][name="/auctions[type]"]', visible: :all
  end
end
