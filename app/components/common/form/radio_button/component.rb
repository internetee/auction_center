module Common
  module Form
    module RadioButton
      class Component < ApplicationViewComponent
        attr_reader :form, :title, :attribute, :data_attributes, :style, :checkbox_id

        def initialize(form:, title:, attribute:, data_attributes:, options: {})
          super

          @form = form
          @title = title
          @attribute = attribute
          @data_attributes = data_attributes
          @style = options[:style]
          @checkbox_id = options[:id]
        end
      end
    end
  end
end
