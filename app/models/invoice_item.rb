class InvoiceItem < ApplicationRecord
  belongs_to :invoice, optional: false
  validates :cents, numericality: { only_integer: true, greater_than: 0 }
  validates :name, presence: true

  def price
    Money.new(cents, Setting.find_by(code: 'auction_currency').retrieve)
  end
end
