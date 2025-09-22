module Common
  module Timer
    class Component < ApplicationViewComponent
      attr_reader :auction

      def initialize(auction:)
        super()

        @auction = auction
      end
    end
  end
end
