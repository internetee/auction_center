module Common
  module Form
    module PasswordField
      class Component < ApplicationViewComponent

        attr_reader :form, :attribute, :autocomple, :autofocus, :label_caption

        def initialize(form:, attribute:, options:)
          super

          @form = form
          @attribute = attribute

          @autocomple = options[:autocomple]
          @autofocus = options[:autofocus]
          @label_caption = options[:label_caption]
        end
      end
    end
  end
end
