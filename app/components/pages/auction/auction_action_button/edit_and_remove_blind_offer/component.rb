module Pages
  module Auction
    module AuctionActionButton
      module EditAndRemoveBlindOffer
        class Component < ApplicationViewComponent
          attr_reader :user, :auction

          def initialize(user:, auction:)
            super()

            @user = user
            @auction = auction
          end
        end
      end
    end
  end
end
