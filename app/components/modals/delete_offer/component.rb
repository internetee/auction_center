module Modals
  module DeleteOffer
    class Component < ApplicationViewComponent
      attr_reader :offer

      def initialize(offer:)
        super

        @offer = offer
      end
    end
  end
end