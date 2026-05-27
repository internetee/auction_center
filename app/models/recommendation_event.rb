class RecommendationEvent < ApplicationRecord
  EVENT_TYPES = %w[
    auction_impression
    auction_click
    auction_detail_view
    wishlist_add
    wishlist_remove
    bid_create
    bid_update
    recommendation_profile_completed
    recommendation_prompt_dismissed
  ].freeze

  belongs_to :user, optional: true
  belongs_to :auction, optional: true

  validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }
  validates :occurred_at, presence: true
end
