class EnablePgvectorAndAddEmbeddings < ActiveRecord::Migration[7.0]
  def up
    # AWS RDS Postgres 17.4 supports pgvector natively. The extension is
    # in the rds_extensions allowlist; CREATE EXTENSION requires a role
    # with rds_superuser. If the app user lacks the privilege, run this
    # SQL once manually as the master user per environment, then mark
    # the migration as applied (rails db:migrate:up VERSION=...).
    enable_extension 'vector' unless extension_enabled?('vector')

    add_column :domain_classifications, :embedding, :vector, limit: 1536
    add_column :domain_classifications, :embedding_model, :string
    add_column :domain_classifications, :embedded_at, :datetime

    # HNSW index on cosine distance for fast nearest-neighbor search.
    execute <<~SQL
      CREATE INDEX IF NOT EXISTS idx_domain_classifications_embedding
        ON domain_classifications
        USING hnsw (embedding vector_cosine_ops)
    SQL
  end

  def down
    execute 'DROP INDEX IF EXISTS idx_domain_classifications_embedding'
    remove_column :domain_classifications, :embedded_at
    remove_column :domain_classifications, :embedding_model
    remove_column :domain_classifications, :embedding
    # Intentionally do NOT disable the vector extension on rollback;
    # other tables or environments may rely on it.
  end
end
