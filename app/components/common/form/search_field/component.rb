module Common
  module Form
    module SearchField
      class Component < ApplicationViewComponent
        attr_reader :form, :attribute, :value, :placeholder

        def initialize(form:, attribute:, value:, placeholder:)
          super()

          @form = form
          @attribute = attribute
          @value = value
          @placeholder = placeholder
        end
      end
    end
  end
end