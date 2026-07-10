class AddEmbeddingEnrichmentToDomainClassifications < ActiveRecord::Migration[7.0]
  # v3 embedding enrichment (see docs/technical/recommendation-embedding-enrichment.md):
  #
  # - description: a 1-2 sentence LLM summary of what the domain is for. Feeds the
  #   embedding input so semantically-similar domains cluster (previously the
  #   input was only "<domain_name>. <keywords>", a deliberately sparse signal —
  #   ADR-001 — that under-served interest/wishlist matching).
  # - embedding_input_version: which DomainEmbedder input format produced the
  #   stored vector. Lets DomainClassification.needs_embedding re-embed rows built
  #   under an older format without a full LLM re-classification.
  def change
    add_column :domain_classifications, :description, :text
    add_column :domain_classifications, :embedding_input_version, :integer
  end
end
