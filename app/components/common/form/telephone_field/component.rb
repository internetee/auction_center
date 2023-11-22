module Common
  module Form
    module TelephoneField
      class Component < ApplicationViewComponent
        attr_reader :attribute, :form, :options

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