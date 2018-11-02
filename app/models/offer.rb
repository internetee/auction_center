class Offer < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :auction, required: true

  validates :cents, numericality: { only_integer: true, greater_than: 0 }
  validate :auction_must_be_active
  validate :must_be_higher_than_minimum_offer

  def auction_must_be_active
    active_auction = Auction.active.find_by(id: auction_id)
    return if active_auction

    errors.add(:auction, 'must be active')
  end

  def must_be_higher_than_minimum_offer
    minimum_offer = Setting.auction_minimum_offer
    return if minimum_offer <= cents.to_i

    currency = Setting.auction_currency
    minimum_offer_as_money = Money.new(minimum_offer, currency)

    errors.add(:price, "must be higher than #{minimum_offer_as_money}")
  end

  def can_be_modified?
    auction.in_progress?
  end

  def price
    Money.new(cents, Setting.auction_currency)
  end

  def price=(value)
    number = value.to_d
    price = Money.from_amount(number, Setting.auction_currency)
    self.cents = price.cents
  end
end
