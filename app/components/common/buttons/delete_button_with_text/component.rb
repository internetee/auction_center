module Common
  module Buttons
    module DeleteButtonWithText
      class Component < ApplicationViewComponent
        attr_reader :path, :text

        def initialize(path:, text:)
          super

          @path = path
          @text = text
        end
      end
    end
  end
end
