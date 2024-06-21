module Common
  module ActionButton
    class Component < ApplicationViewComponent
      attr_reader :type, :href, :color, :options

      def initialize(type:, href:, color: 'ghost', options: {})
        super

        @type = type
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
