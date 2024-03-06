module Common
  module Pagy
    class Component < ApplicationViewComponent
      include PagyHelper

      attr_reader :pagy

      def initialize(pagy:)
        @pagy = pagy

        super
      end
    end
  end
end
