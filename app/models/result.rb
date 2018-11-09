require 'auction_not_finished'
require 'auction_not_found'

class Result < ApplicationRecord
  belongs_to :auction, required: true, inverse_of: :result
  belongs_to :user, required: false

  validates :sold, presence: true

  def self.create_from_auction(auction_id)
    auction = Auction.find_by(id: auction_id)

    if auction
      if auction.finished?
        # Result.create!(auction: auction, user: auction.winning_offer.user,
        #                cents: auction.winning_offer.cents, sold: auction.winning_offer.user)
      else
        raise(Errors::AuctionNotFinished, auction_id)
      end
    else
      raise(Errors::AuctionNotFound, auction_id)
    end
  end
end
