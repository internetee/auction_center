module Pages
  module Auction
    module AuctionActionButton
      class Component < ApplicationViewComponent
        attr_reader :user, :auction, :updated

        def initialize(user:, auction:, updated: false)
          super()

          @user = user
          @auction = auction
          @updated = updated
        end

        def deposit_value
          if auction.allow_to_set_bid?(user)
            return {
              link_title: I18n.t('auctions.bid'),
              color: 'green'
            }

          end

          {
            link_title: I18n.t('auctions.deposit'),
            color: 'orange'
          }
        end
      end
    end
  end
end
