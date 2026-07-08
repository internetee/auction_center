require 'test_helper'

module Recommendation
  class EmbeddingTest < ActiveSupport::TestCase
    def test_cosine_similarity_of_identical_vectors_is_one
      assert_in_delta 1.0, Recommendation::Embedding.cosine_similarity([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), 1e-9
    end

    def test_cosine_similarity_of_orthogonal_vectors_is_zero
      assert_in_delta 0.0, Recommendation::Embedding.cosine_similarity([1.0, 0.0], [0.0, 1.0]), 1e-9
    end

    def test_cosine_similarity_is_nil_for_mismatched_sizes
      assert_nil Recommendation::Embedding.cosine_similarity([1.0, 2.0], [1.0])
    end

    def test_cosine_similarity_is_nil_for_zero_magnitude_vector
      assert_nil Recommendation::Embedding.cosine_similarity([0.0, 0.0], [1.0, 1.0])
    end

    def test_weighted_centroid_averages_by_weight
      centroid = Recommendation::Embedding.weighted_centroid([[[0.0, 0.0], 1.0], [[4.0, 8.0], 3.0]])

      # (0*1 + 4*3) / 4 = 3.0 ; (0*1 + 8*3) / 4 = 6.0
      assert_in_delta 3.0, centroid[0], 1e-9
      assert_in_delta 6.0, centroid[1], 1e-9
    end

    def test_weighted_centroid_is_nil_when_empty
      assert_nil Recommendation::Embedding.weighted_centroid([])
    end

    def test_weighted_centroid_skips_vectors_of_a_different_size
      centroid = Recommendation::Embedding.weighted_centroid([[[1.0, 1.0], 1.0], [[9.9, 9.9, 9.9], 1.0]])

      assert_equal [1.0, 1.0], centroid
    end
  end
end
