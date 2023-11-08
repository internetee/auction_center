module Common
  module Form
    module DropdownInput
      class Component < ApplicationViewComponent
        attr_reader :form, :attribute, :enum, :label, :include_blank

        def initialize(form:, attribute:, label:, enum:, include_blank: false, **options)
          super

          @form = form
          @attribute = attribute
          @enum = enum
          @label = label
          @include_blank = include_blank
        end
      end
    end
  end
end
