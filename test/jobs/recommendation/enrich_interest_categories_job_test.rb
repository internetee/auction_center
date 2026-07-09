require 'test_helper'

module Recommendation
  class EnrichInterestCategoriesJobTest < ActiveJob::TestCase
    def setup
      super
      Setting.find_by(code: 'openai_model')&.update!(value: 'gpt-5')
      InterestCategory.delete_all
    end

    def test_noop_when_openai_disabled
      with_feature_flag(false) do
        assert_nil Recommendation::EnrichInterestCategoriesJob.new.perform
      end
    end

    def test_enriches_and_persists_active_categories
      category = create_category('finance', 'Finance and fintech', 'Finants ja fintech')

      with_feature_flag(true) do
        stub_enrichment(%w[finance])
        stub_embeddings(1)
        Recommendation::EnrichInterestCategoriesJob.new.perform
      end

      category.reload
      assert_equal 'Money things.', category.description
      assert_includes category.keywords, 'finants'
      assert_equal Recommendation::DomainEmbedder::DIMENSIONS, category.embedding.size
      assert category.embedded_at.present?
    end

    def test_single_id_only_enriches_that_category
      target = create_category('finance', 'Finance', 'Finants')
      create_category('travel', 'Travel', 'Reisimine')

      with_feature_flag(true) do
        stub_enrichment(%w[finance])
        stub_embeddings(1)
        Recommendation::EnrichInterestCategoriesJob.new.perform(target.id)
      end

      assert target.reload.embedded_at.present?
      assert_nil InterestCategory.find_by(code: 'travel').embedded_at
    end

    def test_needs_to_run_reflects_unembedded_active_categories
      create_category('finance', 'Finance', 'Finants')

      with_feature_flag(true) do
        assert Recommendation::EnrichInterestCategoriesJob.needs_to_run?
      end
      with_feature_flag(false) do
        refute Recommendation::EnrichInterestCategoriesJob.needs_to_run?
      end
    end

    private

    def create_category(code, name_en, name_et)
      InterestCategory.create!(code: code, name_en: name_en, name_et: name_et, active: true)
    end

    def with_feature_flag(enabled)
      original = Feature.method(:open_ai_integration_enabled?)
      Feature.define_singleton_method(:open_ai_integration_enabled?) { enabled }
      yield
    ensure
      Feature.define_singleton_method(:open_ai_integration_enabled?, original)
    end

    def stub_enrichment(codes)
      body = {
        'choices' => [{
          'finish_reason' => 'stop',
          'message' => {
            'content' => {
              categories: codes.map { |c| { code: c, description: 'Money things.', keywords: %w[finance finants] } }
            }.to_json
          }
        }]
      }
      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .to_return_json(status: 200, body: body, headers: {})
    end

    def stub_embeddings(count)
      data = count.times.map { |i| { 'index' => i, 'embedding' => Array.new(Recommendation::DomainEmbedder::DIMENSIONS, 0.1) } }
      stub_request(:post, 'https://api.openai.com/v1/embeddings')
        .to_return_json(status: 200, body: { 'data' => data }, headers: {})
    end
  end
end
