module Common
  module Form
    module FormButton
      class Component < ApplicationViewComponent
        attr_reader :btn_title, :form, :color, :options

        def initialize(btn_title:, form:, color: 'green', options: {})
          super()

          @btn_title = btn_title
          @form = form
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
