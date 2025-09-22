module Common
  module Badgets
    class Component < ApplicationViewComponent
      attr_reader :status

      def initialize(status:)
        super()

        @status = status
      end

      def badget_class
        classes[status]
      end

      def classes
        {
          'paid' => 'c-badge c-badge--green',
          'prepayment' => 'c-badge c-badge--green c-badge--circle',
          'returned' => 'c-badge c-badge--blue',
          'pending' => 'c-badge c-badge--yellow'
        }
      end
    end
  end
end
