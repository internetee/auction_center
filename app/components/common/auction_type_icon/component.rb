module Common
  module AuctionTypeIcon
    class Component < ApplicationViewComponent
      attr_reader :auction

      def initialize(auction:)
        @auction = auction

        super
      end

      def english?
        auction.english?
      end
    end
  end
end
