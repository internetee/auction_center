module Recommendation
  class RefreshSingleUserAuctionScoresJob < ApplicationJob
    retry_on StandardError, wait: 5.seconds, attempts: 3

    def perform(user_id)
      user = User.find_by(id: user_id)
      return unless user

      Recommendation::Scorer.refresh_for(user:)
    end
  end
end
