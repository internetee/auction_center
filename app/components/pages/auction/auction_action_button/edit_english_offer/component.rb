module Pages
  module Auction
    module AuctionActionButton
      module EditEnglishOffer
        class Component < ApplicationViewComponent
          attr_reader :auction

          def initialize(auction:)
            super

            @auction = auction
          end
        end
      end
    end
  end
end