module Recommendation
  # Pure vector math for the embedding-similarity multiplier. No DB, no models:
  # OpenAI embeddings arrive as plain Float arrays (Postgres double precision[],
  # no pgvector), so this stays trivially unit-testable in isolation.
  module Embedding
    module_function

    # Weighted average of equal-length vectors. `weighted_vectors` is a list of
    # [vector, weight] pairs; a vector whose size differs from the first kept
    # one is skipped (defensive against an embedding-model dimension change).
    # Returns nil when nothing usable was supplied.
    def weighted_centroid(weighted_vectors)
      sum = nil
      total_weight = 0.0

      weighted_vectors.each do |vector, weight|
        vec = Array(vector)
        next if vec.empty?

        sum ||= Array.new(vec.size, 0.0)
        next if vec.size != sum.size

        vec.each_with_index { |v, i| sum[i] += v.to_f * weight }
        total_weight += weight
      end

      return nil if sum.nil? || total_weight.zero?

      sum.map { |v| v / total_weight }
    end

    # Cosine similarity of two equal-length vectors, or nil when it is undefined
    # (mismatched sizes, a zero-magnitude vector).
    def cosine_similarity(vec_a, vec_b)
      return nil if vec_a.nil? || vec_b.nil? || vec_a.size != vec_b.size

      dot = 0.0
      norm_a = 0.0
      norm_b = 0.0
      vec_a.each_with_index do |a, i|
        b = vec_b[i].to_f
        dot += a * b
        norm_a += a * a
        norm_b += b * b
      end

      denom = Math.sqrt(norm_a) * Math.sqrt(norm_b)
      return nil if denom.zero?

      dot / denom
    end
  end
end
