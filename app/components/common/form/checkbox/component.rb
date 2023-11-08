module Common
  module Form
    module Checkbox
      class Component < ApplicationViewComponent
        attr_reader :label_title, :form, :attribute

        def initialize(label_title:, form:, attribute:)
          super

          @label_title = label_title
          @form = form
          @attribute = attribute
        end
      end
    end
  end
end