module Common
  module Badgets
    class Component < ApplicationViewComponent
      attr_reader :status

      def initialize(status:)
        super

        @status = status
      end

      # rubocop:disable Style/HashLikeCase
      def badget_class
        case status
        when 'paid'
          'c-badge c-badge--green'
        when 'prepayment'
          'c-badge c-badge--green c-badge--circle'
        when 'returned'
          'c-badge c-badge--blue'
        when 'pending'
          'c-badge c-badge--yellow'
        end
      end
    end
  end
end
