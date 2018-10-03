class BillingProfile < ApplicationRecord
  belongs_to :user, required: true

  validates :street, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true

  validates :vat_code, presence: true, if: Proc.new {|i| i.legal_entity }
end
