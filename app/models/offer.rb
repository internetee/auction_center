class Offer < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :auction, required: true

  validate :auction_must_be_active, on: :create

  def auction_must_be_active
    active_auction = Auction.active.find_by(id: auction_id)
    return if active_auction

    errors.add(:auction, 'must be active')
  end
end
