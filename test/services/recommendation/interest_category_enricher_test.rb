require 'test_helper'

module Recommendation
  class InterestCategoryEnricherTest < ActiveSupport::TestCase
    def setup
      super
      Setting.find_by(code: 'openai_model')&.update!(value: 'gpt-5')
    end

    def test_returns_description_keywords_and_embedding_per_category
      categories = [
        InterestCategory.new(code: 'finance', name_en: 'Finance and fintech', name_et: 'Finants ja fintech'),
        InterestCategory.new(code: 'real_estate', name_en: 'Real estate', name_et: 'Kinnisvara')
      ]

      stub_enrichment_response(%w[finance real_estate])
      stub_embedding_request(2)

      result = Recommendation::InterestCategoryEnricher.call(categories: categories)

      assert_equal 2, result.size
      finance = result.find { |r| r[:code] == 'finance' }
      assert_equal 'Money things.', finance[:description]
      assert_includes finance[:keywords], 'finants'
      assert_equal Recommendation::DomainEmbedder::DIMENSIONS, finance[:embedding].size
      assert_equal Recommendation::DomainEmbedder::MODEL, finance[:embedding_model]
      assert finance[:embedded_at].is_a?(Time)
    end

    def test_empty_input_returns_empty
      assert_equal [], Recommendation::InterestCategoryEnricher.call(categories: [])
    end

    def test_skips_blank_codes
      categories = [InterestCategory.new(code: '  ', name_en: 'x', name_et: 'x')]
      assert_equal [], Recommendation::InterestCategoryEnricher.call(categories: categories)
    end

    private

    def stub_enrichment_response(codes)
      body = {
        'choices' => [{
          'finish_reason' => 'stop',
          'message' => {
            'content' => {
              categories: codes.map do |code|
                { code: code, description: 'Money things.', keywords: %w[finance finants loan laen] }
              end
            }.to_json
          }
        }]
      }
      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .to_return_json(status: 200, body: body, headers: {})
    end

    def stub_embedding_request(count)
      data = count.times.map do |i|
        { 'index' => i, 'embedding' => Array.new(Recommendation::DomainEmbedder::DIMENSIONS, 0.1) }
      end
      stub_request(:post, 'https://api.openai.com/v1/embeddings')
        .to_return_json(status: 200, body: { 'data' => data, 'model' => 'text-embedding-3-small' }, headers: {})
    end
  end
end
