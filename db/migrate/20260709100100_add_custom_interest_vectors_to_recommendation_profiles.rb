class AddCustomInterestVectorsToRecommendationProfiles < ActiveRecord::Migration[7.0]
  # v3 unified embedding space: each free-text custom interest is embedded into
  # its own vector (a separate "magnet"), not string-matched via LIKE. Stored
  # as jsonb [{ "text" => ..., "embedding" => [..1536..] }, ...] because a
  # profile can hold several heterogeneous custom interests and averaging them
  # into one vector would blur them.
  # See docs/planning/recommendation-v3-unified-embedding-plan.md.
  def change
    add_column :recommendation_profiles, :custom_interest_vectors, :jsonb, default: [], null: false
    add_column :recommendation_profiles, :custom_interests_embedded_at, :datetime
  end
end
