module Common
  module Hero
    class Component < ApplicationViewComponent
    
      attr_reader :title

      def initialize(title:)
        super

        @title = title
      end
    end
  end
end