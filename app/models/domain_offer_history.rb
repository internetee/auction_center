class DomainOfferHistory < ApplicationRecord
  belongs_to :auction
  belongs_to :billing_profile

  def bid
    Money.new(bid_in_cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def bid=(value)
    number = value.to_d
    deposit = Money.from_amount(number, Setting.find_by(code: 'auction_currency').retrieve)
    self.bid_in_cents = deposit.cents
  end
end
