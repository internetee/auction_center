module Common
  module Form
    module Checkboxes
      module CheckboxWithLabel
        class Component < ApplicationViewComponent
          attr_reader :label_title, :form, :attribute, :options

          def initialize(label_title:, form:, attribute:, options: {})
            super

            @label_title = label_title
            @form = form
            @attribute = attribute
            @options = options
          end
        end
      end
    end
  end
end
