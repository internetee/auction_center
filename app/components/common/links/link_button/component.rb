module Common
  module Links
    module LinkButton
      class Component < ApplicationViewComponent
        attr_reader :link_title, :href, :color, :data_attributes

        def initialize(link_title:, href:, color: 'green', data_attributes: {})
          super

          @link_title = link_title
          @href = href
          @color = color
          @data_attributes = data_attributes
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