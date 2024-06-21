module Common
  module Form
    module RadioButton

      # https://auction.test/rails/view_components/common/form/radio_button/component/with_multiple_components
      class ComponentPreview < ViewComponent::Preview
        layout false

        include ActionView::Helpers::FormHelper
        include ActionView::Context

        def with_multiple_components
          form = ActionView::Helpers::FormBuilder.new(auctions_path, nil, self, {})

          render(
            Common::Form::RadioButton::Component.new(
                   form: form, title: 'english', attribute: :type, data_attributes: { **form_filter_target },
                   options: { **radio_btn_style, id: 'filter_IO_button' }
                 )

          )

          tag.label :type_english, class: 'c-table__filters__btn js-table-filter-btn', style: 'cursor: pointer;', for: 'filter_IO_button', data: { **form_filter_data_attrs } do
            tag.span(class: 'o-io-icon') + tag.span('English auction', class: 'u-hidden-m')
          end

          render(Common::Form::RadioButton::Component.new(
                   form:, title: 'blind', attribute: :type, data_attributes: { **form_filter_target },
                   options: { **radio_btn_style, id: 'filter_PO_button' }
                 ))

          # tag.label :type_blind, class: 'c-table__filters__btn js-table-filter-btn', style: 'cursor: pointer;', for: 'filter_PO_button', data: { **form_filter_data_attrs } do
          #   tag.span(class: 'o-po-icon') + tag.span('Blind auction', class: 'u-hidden-m')
          # end

          # label2 = tag.label :type_blind, class: 'c-table__filters__btn js-table-filter-btn', style: 'cursor: pointer;',
          #                        for: 'filter_PO_button', data: { **form_filter_data_attrs } do
          #   tag.span(class: 'o-po-icon') + tag.span(class: 'u-hidden-m') { I18n.t('auction.blind_auction') }
          # end
          # render(label2)
        end

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
    end
  end
end
