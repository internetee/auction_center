module Common
  module Buttons
    module ButtonTo
      class Component < ApplicationViewComponent
        attr_reader :title_caption, :href, :data_attributes, :color, :target, :method, :form_attributes

        def initialize(title_caption:, href:, data_attributes: {}, color: 'blue-secondary', target: '_top', method: :post, form_attributes: {})
          super

          @title_caption = title_caption
          @href = href
          @data_attributes = data_attributes
          @target = target
          @color = color
          @method = method
          @form_attributes = form_attributes
        end

        def colorize
          colors_hash[color]
        end

        def colors_hash
          {
            'blue-secondary' => 'c-btn--blue-secondary',
            'green' => 'c-btn--green',
            'blue' => 'c-btn--blue',
            'orange' => 'c-btn--orange',
            'black' => 'c-btn--black',
            'ghost' => 'c-btn--ghost'
          }
        end
      end
    end
  end
end
