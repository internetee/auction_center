class UserAuctionScore < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  validates :score, presence: true, numericality: true
  validates :calculated_at, presence: true
  validates :auction_id, uniqueness: { scope: :user_id }
end
