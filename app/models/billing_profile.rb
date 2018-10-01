class BillingProfile < ApplicationRecord
  belongs_to :user, required: true

  validates :street, presence: true
  validates :city, presence: true
  validates :postal_index, presence: true
  validates :country, presence: true
end
