module Common
  module Form
    module TextField
      class Component < ApplicationViewComponent

        attr_reader :form, :attribute, :options

        def initialize(form:, attribute:, options: {})
          super

          @form = form
          @attribute = attribute
          @options = options
        end
      end
    end
  end
end
