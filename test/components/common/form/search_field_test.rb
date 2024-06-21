require "test_helper"

class Common::Form::SearchField::ComponentTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper

  def test_render_component
    form = ActionView::Helpers::FormBuilder.new(route.auctions_path, nil, self, { })

    render_inline(Common::Form::SearchField::Component.new(
      form: form, attribute: :domain_name, value: nil, placeholder: I18n.t('search_by_domain_name')
    ))

    assert_selector "input.c-table__search__input.js-table-search-dt[type='search'][name='/auctions[domain_name]'][id='_auctions_domain_name'][placeholder='#{I18n.t('search_by_domain_name')}']"
  end
end
