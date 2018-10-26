class Offer < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :auction, required: true

  validate :auction_must_be_active
  validates :cents, numericality: { only_integer: true, greater_than: 0 }

  def auction_must_be_active
    active_auction = Auction.active.find_by(id: auction_id)
    return if active_auction

    errors.add(:auction, 'must be active')
  end

  def price
    Money.new(cents, 'EUR')
  end

  def price=(value)
    number = value.to_d
    price = Money.from_amount(number, 'EUR')
    self.cents = price.cents
  end
end
