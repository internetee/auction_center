class EnablePgvectorAndAddEmbeddings < ActiveRecord::Migration[7.0]
  # Phase 5 of recommendation v2 originally planned to add a pgvector
  # `embedding` column to `domain_classifications`. That path was dropped
  # to avoid touching the shared dev Postgres image and the shared RDS
  # extension landscape (see docs/architecture/adr-001-recommendation-v2.md).
  #
  # This migration is intentionally a no-op so:
  # - Fresh environments that have never applied it skip cleanly.
  # - Local dev environments that earlier applied an embedding column
  #   get it removed on next run.
  # - Production never had embedding columns, so this is harmless there.
  def up
    if column_exists?(:domain_classifications, :embedding)
      execute 'DROP INDEX IF EXISTS idx_domain_classifications_embedding'
      remove_column :domain_classifications, :embedding
      remove_column :domain_classifications, :embedding_model if column_exists?(:domain_classifications, :embedding_model)
      remove_column :domain_classifications, :embedded_at if column_exists?(:domain_classifications, :embedded_at)
    end
  end

  def down
    # Nothing to roll back to — the embedding feature is not part of v2.
  end
end
