module Recommendation
  class ClassifyAuctionDomainsJob < ApplicationJob
    retry_on StandardError, wait: 5.seconds, attempts: 3

    def perform(auction_ids = nil)
      return unless self.class.needs_to_run?

      auctions = self.class.scope_for(auction_ids)
      should_refresh_scores = auctions.exists?
      Recommendation::AuctionDomainClassifier.call(auctions:)
      Recommendation::RefreshUserAuctionScoresJob.perform_later if should_refresh_scores
    end

    def self.needs_to_run?
      Feature.open_ai_integration_enabled? && scope_for.exists?
    end

    def self.scope_for(auction_ids = nil)
      scope = auction_ids.present? ? Auction.where(id: auction_ids) : Auction.active
      scope.where(classified_at: nil).or(scope.where('classified_at < ?', 7.days.ago))
    end
  end
end
