module Common
  module Buttons
    module ButtonTo
      class Component < ApplicationViewComponent
        attr_reader :title_caption, :link, :data_turbo, :color, :target

        def initialize(title_caption:, link:, data_turbo: false, color: 'blue-secondary', target: '_top')
          super

          @title_caption = title_caption
          @link = link
          @data_turbo = data_turbo
          @target = target
          @color = color
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
