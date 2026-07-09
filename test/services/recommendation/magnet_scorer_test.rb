require 'test_helper'

module Recommendation
  # v3 shadow-mode scorer. Skipped before the embedding column is migrated so
  # the suite stays green on older schemas (mirrors ScorerEmbeddingTest).
  class MagnetScorerTest < ActiveSupport::TestCase
    ALIGNED = Array.new(8, 1.0).freeze
    ORTHOGONAL = [1.0, 0, 0, 0, 0, 0, 0, 0].freeze

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

    def test_category_magnet_ranks_aligned_domain_first
      seed_category('saas', ALIGNED)
      @user.create_recommendation_profile!(interest_keywords: %w[saas])

      aligned = classified_auction('aligned.ee', ALIGNED)
      orthogonal = classified_auction('orthogonal.ee', ORTHOGONAL)

      ranking = rank([aligned, orthogonal])

      assert_equal aligned.id, ranking.first.first.id
      assert ranking.first.last > ranking.last.last
    end

    def test_custom_interest_vector_acts_as_a_magnet
      profile = @user.create_recommendation_profile!(interest_keywords: %w[other custom:crypto])
      profile.update_columns(custom_interest_vectors: [{ 'text' => 'crypto', 'embedding' => ALIGNED }])

      aligned = classified_auction('coin.ee', ALIGNED)
      orthogonal = classified_auction('paper.ee', ORTHOGONAL)

      ranking = rank([aligned, orthogonal])

      assert_equal aligned.id, ranking.first.first.id
    end

    def test_bid_history_acts_as_a_magnet
      history = ended_auction('history.ee')
      place_offer(history)
      classify('history.ee', ALIGNED)

      aligned = classified_auction('similar.ee', ALIGNED)
      orthogonal = classified_auction('different.ee', ORTHOGONAL)

      ranking = rank([aligned, orthogonal])

      assert_equal aligned.id, ranking.first.first.id
    end

    def test_score_is_nil_without_auction_embedding
      seed_category('saas', ALIGNED)
      @user.create_recommendation_profile!(interest_keywords: %w[saas])

      bare = classified_auction('bare.ee', nil)

      scores = Recommendation::MagnetScorer.new(user: @user, scope: Auction.where(id: bare.id)).scores
      assert_nil scores[bare.id]
    end

    def test_score_is_nil_without_any_magnet
      @user.recommendation_profile&.destroy
      candidate = classified_auction('lonely.ee', ALIGNED)

      scores = Recommendation::MagnetScorer.new(user: @user, scope: Auction.where(id: candidate.id)).scores
      assert_nil scores[candidate.id]
    end

    def test_defaults_scope_to_active_auctions
      seed_category('saas', ALIGNED)
      @user.create_recommendation_profile!(interest_keywords: %w[saas])
      classified_auction('default-scope.ee', ALIGNED)

      # No scope: argument — must fall back to Auction.active without raising.
      assert_nothing_raised do
        Recommendation::MagnetScorer.new(user: @user).ranked(limit: 1)
      end
    end

    private

    def rank(auctions)
      Recommendation::MagnetScorer
        .new(user: @user, scope: Auction.where(id: auctions.map(&:id)))
        .ranked
    end

    def seed_category(code, embedding)
      category = InterestCategory.find_or_create_by!(code: code) do |c|
        c.name_en = code.upcase
        c.name_et = code.upcase
        c.active = true
      end
      category.update_columns(embedding: embedding, embedded_at: Time.current)
      category
    end

    def classified_auction(domain_name, embedding)
      auction = Auction.create!(
        domain_name: domain_name,
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        classification_tags: %w[saas],
        primary_category: 'saas',
        skip_validation: true
      )
      classify(domain_name, embedding) unless embedding.nil?
      auction
    end

    def ended_auction(domain_name)
      Auction.create!(
        domain_name: domain_name,
        starts_at: 2.days.ago,
        ends_at: 1.day.ago,
        skip_validation: true
      )
    end

    def classify(domain_name, embedding)
      DomainClassification.create!(
        domain_name: domain_name,
        primary_category: 'saas',
        tags: %w[saas],
        keywords: %w[cloud],
        embedding: embedding,
        classified_at: 1.hour.ago,
        confidence: 0.9
      )
    end

    def place_offer(auction, cents: 100)
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
