class Autobider < ApplicationRecord
  belongs_to :user
  # after_create :maybe_first_bid

  def price
    Money.new(cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def price=(value)
    price = Money.from_amount(value.to_d, Setting.find_by(code: 'auction_currency').retrieve)
    self.cents = price.cents.positive? ? price.cents : nil
  end

  # def maybe_first_bid
  #   auction = Auction.find_by(domain_name: self.domain_name)
  #   p "--------"
  #   p auction
  #   p "---------"
  #   AutobiderService.autobid(auction)
  # end
end
