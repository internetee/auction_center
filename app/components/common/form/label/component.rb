module Common
  module Form
    module Label
      class Component < ApplicationViewComponent
        attr_reader :attribute, :form, :title, :options

        def initialize(attribute:, form:, title: nil, options: {})
          super

          @attribute = attribute
          @form = form
          @title = title
          @options = options
        end
      end
    end
  end
end
