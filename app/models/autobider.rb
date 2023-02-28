class Autobider < ApplicationRecord
  belongs_to :user

  validates :cents, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :domain_name, uniqueness: { scope: :user_id }

  def price
    Money.new(cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def price=(value)
    price = Money.from_amount(value.to_d, Setting.find_by(code: 'auction_currency').retrieve)
    self.cents = price.cents.positive? ? price.cents : nil
  end
end
