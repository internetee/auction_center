require 'test_helper'

module Recommendation
  class EmbedCustomInterestsJobTest < ActiveJob::TestCase
    def setup
      super
      @user = users(:participant)
    end

    def test_noop_when_openai_disabled
      profile = build_profile(%w[crypto])
      with_feature_flag(false) do
        assert_nil Recommendation::EmbedCustomInterestsJob.new.perform(profile.id)
      end
    end

    def test_embeds_each_custom_interest_as_its_own_vector
      profile = build_profile(['crypto', 'learning platform'])

      with_feature_flag(true) do
        stub_embeddings(2)
        assert_enqueued_with(job: Recommendation::RefreshSingleUserAuctionScoresJob, args: [@user.id]) do
          Recommendation::EmbedCustomInterestsJob.new.perform(profile.id)
        end
      end

      vectors = profile.reload.custom_interest_vectors
      assert_equal %w[crypto learning\ platform].sort, vectors.map { |v| v['text'] }.sort
      assert_equal Recommendation::DomainEmbedder::DIMENSIONS, vectors.first['embedding'].size
      assert profile.custom_interests_embedded_at.present?
    end

    def test_reuses_cached_vectors_for_unchanged_texts
      profile = build_profile(['crypto', 'realty'])
      cached_vector = Array.new(Recommendation::DomainEmbedder::DIMENSIONS, 0.9)
      profile.update_columns(custom_interest_vectors: [{ 'text' => 'crypto', 'embedding' => cached_vector }])

      with_feature_flag(true) do
        stub_embeddings(1) # only 'realty' is missing
        Recommendation::EmbedCustomInterestsJob.new.perform(profile.id)
      end

      vectors = profile.reload.custom_interest_vectors.index_by { |v| v['text'] }
      assert_equal cached_vector, vectors['crypto']['embedding'], 'unchanged text keeps its cached vector'
      assert_equal Recommendation::DomainEmbedder::DIMENSIONS, vectors['realty']['embedding'].size
    end

    def test_clears_vectors_when_no_custom_interests
      profile = build_profile([])
      profile.update_columns(custom_interest_vectors: [{ 'text' => 'stale', 'embedding' => [0.1] }])

      with_feature_flag(true) do
        Recommendation::EmbedCustomInterestsJob.new.perform(profile.id)
      end

      assert_equal [], profile.reload.custom_interest_vectors
      assert profile.custom_interests_embedded_at.present?
    end

    private

    def build_profile(custom_interests)
      with_feature_flag(false) do
        profile = RecommendationProfile.find_or_initialize_by(user: @user)
        profile.custom_interests = custom_interests
        profile.save!
        profile
      end
    end

    def with_feature_flag(enabled)
      original = Feature.method(:open_ai_integration_enabled?)
      Feature.define_singleton_method(:open_ai_integration_enabled?) { enabled }
      yield
    ensure
      Feature.define_singleton_method(:open_ai_integration_enabled?, original)
    end

    def stub_embeddings(count)
      data = count.times.map { |i| { 'index' => i, 'embedding' => Array.new(Recommendation::DomainEmbedder::DIMENSIONS, 0.1) } }
      stub_request(:post, 'https://api.openai.com/v1/embeddings')
        .to_return_json(status: 200, body: { 'data' => data }, headers: {})
    end
  end
end
