module Recommendation
  class RefreshSingleUserAuctionScoresJob < ApplicationJob
    DEBOUNCE_WINDOW = 30.seconds

    retry_on StandardError, wait: 5.seconds, attempts: 3

    def self.enqueue_debounced(user_id)
      set(wait: DEBOUNCE_WINDOW).perform_later(user_id)
    end

    def perform(user_id)
      user = User.find_by(id: user_id)
      return unless user

      # A refresh just ran (<30s ago). Don't drop this request — re-enqueue it
      # for the next window so the change that triggered us isn't silently lost.
      if recently_refreshed?(user)
        self.class.set(wait: DEBOUNCE_WINDOW).perform_later(user_id)
        return
      end

      Recommendation::Scorer.refresh_for(user:)
    end

    private

    def recently_refreshed?(user)
      last_calculated = UserAuctionScore.where(user_id: user.id).maximum(:calculated_at)
      last_calculated.present? && last_calculated > DEBOUNCE_WINDOW.ago
    end
  end
end
