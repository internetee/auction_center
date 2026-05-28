class AddEmbeddingArrayToDomainClassifications < ActiveRecord::Migration[7.0]
  # Embeddings stored as a plain Postgres array of doubles — no pgvector
  # extension required. Cosine similarity is computed in Ruby at scoring
  # time. At our scale (100-200 active auctions per user) brute-force
  # cosine over a few hundred 1536-dim vectors takes ~50ms, well within
  # the RefreshSingleUserAuctionScoresJob budget.
  #
  # If we ever outgrow brute-force (~5k+ vectors), we can either:
  # - Stand up a sidecar pgvector pod and migrate the column type, or
  # - Move to an external vector API (Upstash, Qdrant, Pinecone)
  # The float[] format is portable to all of the above.
  def change
    add_column :domain_classifications, :embedding, :"double precision[]"
    add_column :domain_classifications, :embedding_model, :string
    add_column :domain_classifications, :embedded_at, :datetime

    add_index :domain_classifications, :embedded_at
  end
end
