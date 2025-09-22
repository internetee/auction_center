module Common
  module Buttons
    module ButtonTo
      class Component < ApplicationViewComponent
        attr_reader :title_caption, :href, :color, :options

        def initialize(href:, title_caption: nil, color: 'blue-secondary', options: {})
          super()

          @title_caption = title_caption
          @href = href
          @color = color
          @options = options
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
