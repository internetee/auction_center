class UserAuctionScore < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  validates :score, presence: true, numericality: true
  validates :calculated_at, presence: true
  # Uniqueness of (user_id, auction_id) is enforced by a DB unique index and the
  # upsert_all(unique_by:) write path in Recommendation::Scorer; no form surfaces
  # this, so a redundant AR validation would only add a lost-to-the-DB race.
end
