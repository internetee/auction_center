module Recommendation
  # v3: embeds a profile's free-text custom interests into their own vectors so
  # each acts as a separate magnet in the unified scorer (never averaged, never
  # LIKE-matched). Enqueued from RecommendationProfile when the custom interests
  # change. Reuses already-stored vectors for unchanged texts so editing one
  # interest never re-embeds the rest.
  #
  # On completion it enqueues the debounced rescore so the fresh magnets take
  # effect on the next scoring pass.
  class EmbedCustomInterestsJob < ApplicationJob
    retry_on StandardError, wait: 30.seconds, attempts: 2

    def perform(profile_id)
      return unless Feature.open_ai_integration_enabled?
      return unless RecommendationProfile.column_names.include?('custom_interest_vectors')

      profile = RecommendationProfile.find_by(id: profile_id)
      return unless profile

      texts = profile.custom_interests
      if texts.empty?
        profile.update_columns(custom_interest_vectors: [], custom_interests_embedded_at: Time.current)
        return 0
      end

      vectors = build_vectors(profile, texts)
      profile.update_columns(
        custom_interest_vectors: vectors,
        custom_interests_embedded_at: Time.current
      )
      Recommendation::RefreshSingleUserAuctionScoresJob.enqueue_debounced(profile.user_id)
      vectors.size
    end

    private

    # Keep existing vectors for unchanged texts; embed only the newcomers.
    def build_vectors(profile, texts)
      cached = Array(profile.custom_interest_vectors).index_by { |entry| entry['text'] }
      missing = texts.reject { |text| cached[text] }

      fresh = missing.zip(Recommendation::TextEmbedder.embed(missing)).to_h

      texts.map do |text|
        cached[text] || { 'text' => text, 'embedding' => fresh[text] }
      end
    end
  end
end
