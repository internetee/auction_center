require 'test_helper'

module Recommendation
  class ScorerTest < ActiveSupport::TestCase
    def setup
      super

      @user = users(:signed_in_with_omniauth)
      travel_to Time.zone.parse('2010-07-05 11:30:00 UTC')
    end

    def teardown
      super
      travel_back
    end

    def test_refresh_for_prioritizes_wishlist_category_and_custom_interest_matches
      @user.create_recommendation_profile!(interest_keywords: %w[saas other custom:market])
      WishlistItem.create!(user: @user, domain_name: 'wishlistboost.ee', cents: 1_000)

      wishlist_auction = create_active_auction(domain_name: 'wishlistboost.ee', classification_tags: ['agency'], ai_score: 1.0)
      category_auction = create_active_auction(domain_name: 'cloudstack.ee', classification_tags: ['saas'], ai_score: 1.0)
      custom_auction = create_active_auction(domain_name: 'marketflow.ee', classification_tags: ['agency'], ai_score: 1.0)
      neutral_auction = create_active_auction(domain_name: 'neutral.ee', classification_tags: ['agency'], ai_score: 9.0)

      Recommendation::Scorer.refresh_for(
        user: @user,
        scope: Auction.where(id: [wishlist_auction.id, category_auction.id, custom_auction.id, neutral_auction.id])
      )

      scores = UserAuctionScore.where(user: @user).index_by(&:auction_id)

      assert scores[wishlist_auction.id].score > scores[category_auction.id].score
      assert scores[category_auction.id].score > scores[custom_auction.id].score
      assert scores[custom_auction.id].score > scores[neutral_auction.id].score
      assert_equal Recommendation::Scorer::BASELINE_MODEL_NAME, scores[wishlist_auction.id].scorer_name
    end

    def test_refresh_for_uses_bid_history_tag_affinity
      bidder = users(:participant)
      bidder_offer_auction = auctions(:valid_with_offers)
      bidder_offer_auction.update!(classification_tags: ['numeric'], primary_category: 'numeric')

      matching_auction = create_active_auction(domain_name: '12345.ee', classification_tags: ['numeric'], ai_score: 1.0)
      non_matching_auction = create_active_auction(domain_name: 'brandname.ee', classification_tags: ['shop_brand'], ai_score: 1.0)

      Recommendation::Scorer.refresh_for(
        user: bidder,
        scope: Auction.where(id: [matching_auction.id, non_matching_auction.id])
      )

      matching_score = UserAuctionScore.find_by!(user: bidder, auction: matching_auction).score
      non_matching_score = UserAuctionScore.find_by!(user: bidder, auction: non_matching_auction).score

      assert matching_score > non_matching_score
    end

    private

    def create_active_auction(domain_name:, classification_tags:, ai_score:)
      Auction.create!(
        domain_name:,
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        classification_tags:,
        primary_category: classification_tags.first,
        ai_score:,
        skip_validation: true
      )
    end
  end
end
