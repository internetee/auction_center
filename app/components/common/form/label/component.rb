module Common
  module Form
    module Label
      class Component < ApplicationViewComponent
        attr_reader :attribute, :form, :title, :for_component, :data_attributes, :style, :css_class

        def initialize(attribute:, form:, title:, for_component:, options:, data_attributes: {})
          super

          @attribute = attribute
          @title = title
          @form = form
          @for_component = for_component
          @data_attributes = data_attributes

          @style = options[:style]
          @css_class = options[:css_class]
        end
      end
    end
  end
end

