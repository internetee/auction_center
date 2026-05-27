module Recommendation
  class RefreshUserAuctionScoresJob < ApplicationJob
    retry_on StandardError, wait: 5.seconds, attempts: 3

    def perform(user_ids = nil)
      return unless self.class.needs_to_run?

      self.class.scope_for(user_ids).find_each do |user|
        Recommendation::Scorer.refresh_for(user:)
      end
    end

    def self.needs_to_run?
      Auction.active.exists? && scope_for.exists?
    end

    def self.scope_for(user_ids = nil)
      scope = user_ids.present? ? User.where(id: user_ids) : User.where('? = ANY (roles)', User::PARTICIPANT_ROLE)
      scope.includes(:recommendation_profile)
    end
  end
end
