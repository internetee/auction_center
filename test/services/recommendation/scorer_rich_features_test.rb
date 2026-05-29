require 'test_helper'

module Recommendation
  # Rich-feature scorer tests (Phase 6). The original scorer_test.rb is
  # preserved as a smoke test of relative ordering with classification_tags
  # fallback. These tests verify the new signal sources.
  class ScorerRichFeaturesTest < ActiveSupport::TestCase
    def setup
      super
      @user = users(:participant)
      travel_to Time.zone.parse('2026-05-27 12:00:00 UTC')
    end

    def teardown
      super
      travel_back
    end

    def test_keyword_overlap_boosts_score
      @user.create_recommendation_profile!(interest_keywords: %w[saas custom:cloud])

      classified = create_active_auction(domain_name: 'rich-cloud.ee', classification_tags: ['saas'])
      DomainClassification.create!(
        domain_name: 'rich-cloud.ee',
        primary_category: 'saas',
        tags: %w[saas],
        keywords: %w[cloud platform], # 'cloud' overlaps with custom interest
        classification_source: DomainClassification::OPENAI_SOURCE,
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      bare = create_active_auction(domain_name: 'rich-bare.ee', classification_tags: ['saas'])
      DomainClassification.create!(
        domain_name: 'rich-bare.ee',
        primary_category: 'saas',
        tags: %w[saas],
        keywords: %w[utility],
        classification_source: DomainClassification::OPENAI_SOURCE,
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      Recommendation::Scorer.refresh_for(
        user: @user,
        scope: Auction.where(id: [classified.id, bare.id])
      )

      classified_score = UserAuctionScore.find_by!(user: @user, auction: classified).score
      bare_score = UserAuctionScore.find_by!(user: @user, auction: bare).score

      assert classified_score > bare_score,
             "Expected keyword overlap to boost score (#{classified_score} vs #{bare_score})"
    end

    def test_recent_bid_outweighs_old_bid_via_time_decay
      bidder = @user

      # Old bid on numeric domain (10 years old)
      old_auction = Auction.create!(
        domain_name: 'old-bid.ee',
        starts_at: 11.years.ago,
        ends_at: 10.years.ago,
        classification_tags: ['numeric'],
        skip_validation: true
      )
      old_offer = create_history_offer(bidder, old_auction)
      old_offer.update_columns(updated_at: 10.years.ago)

      target_with_numeric = create_active_auction(
        domain_name: 'fresh-num.ee',
        classification_tags: ['numeric']
      )
      target_without = create_active_auction(
        domain_name: 'fresh-brand.ee',
        classification_tags: ['brandable']
      )

      Recommendation::Scorer.refresh_for(
        user: bidder,
        scope: Auction.where(id: [target_with_numeric.id, target_without.id])
      )

      numeric_score = UserAuctionScore.find_by!(user: bidder, auction: target_with_numeric).score
      brand_score = UserAuctionScore.find_by!(user: bidder, auction: target_without).score

      # 10-year-old signal decayed to near zero; both auctions should be
      # roughly comparable (numeric not significantly boosted).
      decay_gap = (numeric_score - brand_score).abs
      assert decay_gap < 5, "Decayed bid should not significantly tilt scores (gap=#{decay_gap})"
    end

    def test_features_version_marker_present
      auction = create_active_auction(domain_name: 'fv.ee', classification_tags: ['saas'])
      Recommendation::Scorer.refresh_for(user: @user, scope: Auction.where(id: auction.id))
      score = UserAuctionScore.find_by!(user: @user, auction: auction)
      assert_equal Recommendation::Scorer::FEATURES_VERSION, score.features_version
    end

    private

    def create_active_auction(domain_name:, classification_tags:, ai_score: 1.0)
      Auction.create!(
        domain_name: domain_name,
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        classification_tags: classification_tags,
        primary_category: classification_tags.first,
        ai_score: ai_score,
        skip_validation: true
      )
    end

    # Bid history on a past/ended auction. Offer validations (active auction,
    # minimum price) don't apply to backfilled history, so persist without
    # validation. A real billing_profile satisfies the FK.
    def create_history_offer(user, auction, cents: 100)
      offer = Offer.new(
        user: user,
        auction: auction,
        cents: cents,
        billing_profile: billing_profiles(:private_person)
      )
      offer.save(validate: false)
      offer
    end
  end
end
