module Common
  module Form
    module DropdownInput
      class Component < ApplicationViewComponent
        attr_reader :form, :attribute, :enum, :first_options, :second_options

        def initialize(form:, attribute:, enum:, first_options: {}, second_options: {})
          super()

          @form = form
          @attribute = attribute
          @enum = enum
          @first_options = first_options
          @second_options = second_options
        end
      end
    end
  end
end
