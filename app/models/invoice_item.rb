class InvoiceItem < ApplicationRecord
  belongs_to :invoice, required: true
  validates :cents, numericality: { only_integer: true, greater_than: 0 }
end
