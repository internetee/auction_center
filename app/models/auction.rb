class Auction < ApplicationRecord
  validates :domain_name, presence: true
  validates :ends_at, presence: true
end
