require 'test_helper'

module Recommendation
  # v3 Scorer: score = magnet_base × MAGNET_SCALE + structural nudges. Skipped
  # before the embedding column is migrated (magnet base needs it).
  class ScorerTest < ActiveSupport::TestCase
    ALIGNED = Array.new(8, 1.0).freeze
    ORTHOGONAL = [1.0, 0, 0, 0, 0, 0, 0, 0].freeze

    def setup
      super
      skip 'embedding column missing' unless DomainClassification.column_names.include?('embedding')

      @user = users(:participant)
      travel_to Time.zone.parse('2026-05-27 12:00:00 UTC')
      give_user_a_magnet
    end

    def teardown
      super
      travel_back
    end

    def test_writes_scaled_magnet_score_ranking_aligned_above_orthogonal
      aligned = classified_auction('aligned.ee', ALIGNED)
      orthogonal = classified_auction('orthogonal.ee', ORTHOGONAL)

      Recommendation::Scorer.refresh_for(user: @user, scope: Auction.where(id: [aligned.id, orthogonal.id]))

      aligned_score = UserAuctionScore.find_by!(user: @user, auction: aligned).score
      orthogonal_score = UserAuctionScore.find_by!(user: @user, auction: orthogonal).score

      assert aligned_score > orthogonal_score
      # magnet base (~3.0) scaled by 100 dominates the score.
      assert aligned_score > 100, "Expected scaled magnet score, got #{aligned_score}"
    end

    def test_no_row_written_when_candidate_has_no_embedding
      bare = classified_auction('bare.ee', nil)

      count = Recommendation::Scorer.refresh_for(user: @user, scope: Auction.where(id: bare.id))

      assert_equal 0, count
      assert_nil UserAuctionScore.find_by(user: @user, auction: bare)
    end

    def test_stale_row_deleted_when_magnet_disappears
      candidate = classified_auction('lonely.ee', ALIGNED)
      remove_user_magnets # user no longer has any signal → no pull

      UserAuctionScore.create!(user: @user, auction: candidate, score: 42, calculated_at: 1.day.ago)

      Recommendation::Scorer.refresh_for(user: @user, scope: Auction.where(id: candidate.id))

      assert_nil UserAuctionScore.find_by(user: @user, auction: candidate),
                 'stale score row should be deleted once the auction no longer earns a magnet score'
    end

    def test_structural_length_bonus_applied_on_top_of_magnet
      profile = @user.recommendation_profile || @user.create_recommendation_profile!
      profile.update!(preferred_length_min: 1, preferred_length_max: 3)
      short = classified_auction('abc.ee', ALIGNED)   # normalized 'abc' → length 3, in range
      long  = classified_auction('abcdefgh.ee', ALIGNED)

      Recommendation::Scorer.refresh_for(user: @user, scope: Auction.where(id: [short.id, long.id]))

      short_score = UserAuctionScore.find_by!(user: @user, auction: short).score
      long_score = UserAuctionScore.find_by!(user: @user, auction: long).score

      assert_in_delta Recommendation::Scorer::LENGTH_MATCH_BONUS, (short_score - long_score).to_f, 0.01
    end

    def test_features_version_marker_present
      auction = classified_auction('fv.ee', ALIGNED)
      Recommendation::Scorer.refresh_for(user: @user, scope: Auction.where(id: auction.id))
      score = UserAuctionScore.find_by!(user: @user, auction: auction)

      assert_equal Recommendation::Scorer::FEATURES_VERSION, score.features_version
      assert_equal Recommendation::Scorer::SCORER_NAME, score.scorer_name
    end

    private

    # A single behavioural magnet in the ALIGNED direction (a past bid on an
    # embedded domain), so ALIGNED candidates get a strong pull.
    def give_user_a_magnet
      history = Auction.create!(
        domain_name: 'history.ee', starts_at: 2.days.ago, ends_at: 1.day.ago, skip_validation: true
      )
      Offer.new(user: @user, auction: history, cents: 100,
                billing_profile: billing_profiles(:private_person)).save(validate: false)
      classify('history.ee', ALIGNED)
    end

    def remove_user_magnets
      Offer.where(user: @user).delete_all
      @user.wishlist_items.delete_all
      @user.recommendation_profile&.update_columns(interest_keywords: [], custom_interest_vectors: [])
    end

    def classified_auction(domain_name, embedding)
      auction = Auction.create!(
        domain_name: domain_name, starts_at: 1.hour.ago, ends_at: 1.day.from_now,
        classification_tags: %w[saas], primary_category: 'saas', skip_validation: true
      )
      classify(domain_name, embedding) unless embedding.nil?
      auction
    end

    def classify(domain_name, embedding)
      DomainClassification.create!(
        domain_name: domain_name, primary_category: 'saas', tags: %w[saas], keywords: %w[cloud],
        embedding: embedding, classified_at: 1.hour.ago, confidence: 0.9
      )
    end
  end
end
