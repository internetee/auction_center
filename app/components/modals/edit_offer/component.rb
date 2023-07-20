module Modals
  module EditOffer
    class Component < ApplicationViewComponent
      attr_reader :offer, :auction, :autobider

      def initialize(offer:, auction:, autobider:)
        super

        @offer = offer
        @auction = auction
        @autobider = autobider
      end
    end
  end
end
