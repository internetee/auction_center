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
      assert_equal Recommendation::DomainEmbedder::INPUT_VERSION, result.first[:embedding_input_version]
    end

    def test_build_input_includes_classification_fields
      row = {
        domain_name: 'petshop.ee',
        description: 'An online store selling pet food.',
        primary_category: 'ecommerce',
        tags: %w[shop_brand pet_care],
        suggested_use_cases: %w[shop marketplace],
        audience: 'b2c',
        keywords: %w[pets food]
      }

      input = Recommendation::DomainEmbedder.new(rows: []).send(:build_input, row)

      assert_includes input, 'petshop.ee'
      assert_includes input, 'An online store selling pet food.'
      assert_includes input, 'Category: ecommerce'
      assert_includes input, 'Tags: shop brand, pet care' # underscores humanized
      assert_includes input, 'Use cases: shop, marketplace'
      assert_includes input, 'Audience: b2c'
      assert_includes input, 'Keywords: pets, food'
    end

    def test_build_input_skips_blank_fields_without_dangling_labels
      row = { domain_name: 'bare.ee', keywords: %w[minimal] }

      input = Recommendation::DomainEmbedder.new(rows: []).send(:build_input, row)

      assert_equal 'bare.ee. Keywords: minimal', input
      refute_includes input, 'Category:'
      refute_includes input, 'Tags:'
      refute_includes input, ': .'
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
