require "test_helper"

class Components::Common::Form::RadioButtonSystemTest < ViewComponent::TestCase
  include ActionView::Helpers::FormHelper
  include ViewComponent::SystemTestHelpers
  include ActionView::Context

  # def test_multiple_components
  #   form = ActionView::Helpers::FormBuilder.new(route.auctions_path, nil, self, { data: { **form_data_attributes } })

  #   render_inline(Common::Form::RadioButton::Component.new(
  #     form: form, title: 'english', attribute: :type, data_attributes: { form__filter_target: 'button' }, 
  #     options: { style: 'visibility: hidden; position: absolute;', id: 'filter_IO_button'}
  #   ))

  #   tag.label :type_english, class: 'c-table__filters__btn js-table-filter-btn', style: 'cursor: pointer;', for: 'filter_IO_button', data: { **form_filter_data_attrs } do
  #     tag.span(class: 'o-io-icon') + tag.span('English auction', class: 'u-hidden-m')
  #   end

  #   render_inline(Common::Form::RadioButton::Component.new(
  #     form: form, title: 'blind', attribute: :type, data_attributes: { form__filter_target: 'button' }, 
  #     options: { style: 'visibility: hidden; position: absolute;', id: 'filter_PO_button'}
  #   ))

  #   tag.label :type_blind, class: 'c-table__filters__btn js-table-filter-btn', style: 'cursor: pointer;', for: 'filter_PO_button', data: { **form_filter_data_attrs } do
  #     tag.span(class: 'o-po-icon') + tag.span('Blind auction', class: 'u-hidden-m')
  #   end

  #   # visit "/rails/view_components/radio_button_component/default" # URL вашего предварительного просмотра
  #   # render_preview(:with_multiple_components)

  #   puts '====='
  #   puts show_components_html
  #   puts '====='

  # end

  private

  def form_data_attributes
    {
      controller: 'form--debounce form--filter',
      form__debounce_target: 'form',
      form__filter_target: 'form',
      turbo_action: 'advance',
      turbo_frame: 'results',
      action: 'input->form--debounce#search'
    }
  end

  def radio_btn_style
    {
      style: 'visibility: hidden; position: absolute;'
    }
  end

  def form_filter_target
    {
      form__filter_target: 'button'
    }
  end

  def form_filter_data_attrs
    {
      form__filter_target: 'label', action: 'click->form--filter#click'
    }
  end
end