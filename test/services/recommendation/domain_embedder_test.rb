require 'test_helper'

module Recommendation
  class DomainEmbedderTest < ActiveSupport::TestCase
    def test_returns_aligned_embeddings_for_each_row
      rows = [
        { domain_name: 'a.ee', keywords: %w[one] },
        { domain_name: 'b.ee', keywords: %w[two] }
      ]

      stub_embedding_request(2)

      result = Recommendation::DomainEmbedder.call(rows: rows)
      assert_equal 2, result.size
      assert_equal 'a.ee', result.first[:domain_name]
      assert_equal Recommendation::DomainEmbedder::DIMENSIONS, result.first[:embedding].size
      assert_equal Recommendation::DomainEmbedder::MODEL, result.first[:embedding_model]
      assert result.first[:embedded_at].is_a?(Time)
    end

    def test_handles_active_record_rows
      classification = DomainClassification.create!(
        domain_name: 'ar.ee',
        keywords: %w[active record]
      )
      stub_embedding_request(1)

      result = Recommendation::DomainEmbedder.call(rows: [classification])
      assert_equal 'ar.ee', result.first[:domain_name]
      assert_equal Recommendation::DomainEmbedder::DIMENSIONS, result.first[:embedding].size
    end

    def test_empty_input_returns_empty
      result = Recommendation::DomainEmbedder.call(rows: [])
      assert_equal [], result
    end

    def test_raises_on_openai_error
      stub_request(:post, 'https://api.openai.com/v1/embeddings')
        .to_return_json(status: 200, body: { 'error' => { 'message' => 'oops' } }, headers: {})

      assert_raises(StandardError) do
        Recommendation::DomainEmbedder.call(rows: [{ domain_name: 'x.ee', keywords: [] }])
      end
    end

    private

    def stub_embedding_request(count)
      data = count.times.map do |i|
        { 'index' => i, 'embedding' => Array.new(Recommendation::DomainEmbedder::DIMENSIONS, 0.1) }
      end
      stub_request(:post, 'https://api.openai.com/v1/embeddings')
        .to_return_json(status: 200, body: { 'data' => data, 'model' => 'text-embedding-3-small' }, headers: {})
    end
  end
end
