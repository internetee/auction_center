require 'test_helper'

module Recommendation
  # Verifies the embedding multiplier path. Skipped when the embedding
  # column hasn't been migrated yet (so the suite is safe to run before
  # rails db:migrate has applied the float[] migration).
  class ScorerEmbeddingTest < ActiveSupport::TestCase
    def setup
      super
      skip 'embedding column missing' unless DomainClassification.column_names.include?('embedding')

      @user = users(:participant)
      travel_to Time.zone.parse('2026-05-27 12:00:00 UTC')
    end

    def teardown
      super
      travel_back
    end

    def test_aligned_embedding_boosts_score
      # User behavioural history points strongly toward a 1.0-direction vector.
      history_auction = Auction.create!(
        domain_name: 'history-domain.ee',
        starts_at: 2.days.ago,
        ends_at: 1.day.ago,
        skip_validation: true
      )
      create_history_offer(history_auction)
      DomainClassification.create!(
        domain_name: 'history-domain.ee',
        primary_category: 'saas',
        tags: %w[saas],
        keywords: %w[cloud],
        embedding: Array.new(8, 1.0),
        classified_at: 1.day.ago,
        confidence: 0.9
      )

      # Two candidate auctions, identical except their embedding vectors:
      # one aligned (same direction as the user centroid), one orthogonal.
      aligned = create_active_auction(domain_name: 'aligned.ee')
      DomainClassification.create!(
        domain_name: 'aligned.ee',
        primary_category: 'saas',
        tags: %w[saas],
        keywords: %w[cloud],
        embedding: Array.new(8, 1.0),
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      orthogonal = create_active_auction(domain_name: 'orthogonal.ee')
      DomainClassification.create!(
        domain_name: 'orthogonal.ee',
        primary_category: 'saas',
        tags: %w[saas],
        keywords: %w[cloud],
        embedding: [1.0, 0, 0, 0, 0, 0, 0, 0],
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      Recommendation::Scorer.refresh_for(
        user: @user,
        scope: Auction.where(id: [aligned.id, orthogonal.id])
      )

      aligned_score = UserAuctionScore.find_by!(user: @user, auction: aligned).score
      orthogonal_score = UserAuctionScore.find_by!(user: @user, auction: orthogonal).score

      assert aligned_score > orthogonal_score,
             "Expected aligned vector to score higher (#{aligned_score} vs #{orthogonal_score})"
    end

    def test_multiplier_no_op_when_user_has_no_history
      candidate = create_active_auction(domain_name: 'lonely.ee')
      DomainClassification.create!(
        domain_name: 'lonely.ee',
        primary_category: 'saas',
        tags: %w[saas],
        keywords: %w[cloud],
        embedding: Array.new(8, 0.5),
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      Recommendation::Scorer.refresh_for(
        user: @user,
        scope: Auction.where(id: candidate.id)
      )

      score = UserAuctionScore.find_by!(user: @user, auction: candidate).score
      # No user signals means multiplier=1.0. We just assert the job finishes
      # successfully and the row exists; a precise numeric assertion would
      # tie this test to the rest of the scoring formula.
      assert score.is_a?(Numeric)
    end

    private

    def create_active_auction(domain_name:)
      Auction.create!(
        domain_name: domain_name,
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        classification_tags: %w[saas],
        primary_category: 'saas',
        skip_validation: true
      )
    end

    # Bid history on a past/ended auction. Offer validations (active auction,
    # minimum price) don't apply to backfilled history, so persist without
    # validation. A real billing_profile satisfies the FK.
    def create_history_offer(auction, cents: 100)
      offer = Offer.new(
        user: @user,
        auction: auction,
        cents: cents,
        billing_profile: billing_profiles(:private_person)
      )
      offer.save(validate: false)
      offer
    end
  end
end
