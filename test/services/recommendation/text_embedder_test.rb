require 'test_helper'

module Recommendation
  class TextEmbedderTest < ActiveSupport::TestCase
    def test_returns_vectors_aligned_to_input_order
      stub_request(:post, 'https://api.openai.com/v1/embeddings')
        .to_return_json(status: 200, body: {
          'data' => [
            { 'index' => 1, 'embedding' => [0.2, 0.2] },
            { 'index' => 0, 'embedding' => [0.1, 0.1] }
          ]
        }, headers: {})

      result = Recommendation::TextEmbedder.embed(%w[first second])

      assert_equal [[0.1, 0.1], [0.2, 0.2]], result
    end

    def test_empty_input_returns_empty_without_calling_openai
      assert_equal [], Recommendation::TextEmbedder.embed([])
    end

    def test_raises_on_openai_error
      stub_request(:post, 'https://api.openai.com/v1/embeddings')
        .to_return_json(status: 200, body: { 'error' => { 'message' => 'boom' } }, headers: {})

      assert_raises(StandardError) { Recommendation::TextEmbedder.embed(%w[x]) }
    end
  end
end
