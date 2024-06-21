module Pages
  module Auction
    module Filter
      class Component < ApplicationViewComponent
        attr_reader :current_user

        def initialize(current_user:)
          super

          @current_user = current_user
        end

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
            form__filter_target: 'label', action: "click->form--filter#click"
          }
        end
      end
    end
  end
end
