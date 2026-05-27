class EnablePgvectorAndAddEmbeddings < ActiveRecord::Migration[7.0]
  class PgvectorUnavailable < StandardError; end

  # Set to true via the ENV var to skip embedding columns entirely if you
  # are running on a Postgres image without pgvector and cannot upgrade
  # right now (e.g. for a hotfix). The recommendation system degrades to
  # tag/keyword scoring without similarity multiplier.
  SKIP_ENV = 'SKIP_PGVECTOR_MIGRATION'.freeze

  def up
    if ENV[SKIP_ENV] == 'true'
      say 'Skipping pgvector migration because SKIP_PGVECTOR_MIGRATION=true'
      return
    end

    ensure_pgvector_available!
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
    remove_column :domain_classifications, :embedded_at if column_exists?(:domain_classifications, :embedded_at)
    remove_column :domain_classifications, :embedding_model if column_exists?(:domain_classifications, :embedding_model)
    remove_column :domain_classifications, :embedding if column_exists?(:domain_classifications, :embedding)
    # Intentionally do NOT disable the vector extension on rollback;
    # other tables or environments may rely on it.
  end

  private

  # Surfaces a clear error message instead of the cryptic
  # `could not open extension control file "vector.control"` that
  # PostgreSQL produces when the .so is missing.
  def ensure_pgvector_available!
    available = ActiveRecord::Base.connection
                                  .select_value("SELECT 1 FROM pg_available_extensions WHERE name = 'vector'")
    return if available

    raise PgvectorUnavailable, <<~MSG.squish
      pgvector extension is not installed in this PostgreSQL instance.
      Production (AWS RDS Postgres 17) has it natively. For local dev,
      pull pgvector/pgvector:pg13 (or :pg17) instead of plain postgres
      image — see docker-images/docker-compose.dev.v2.yml. To skip this
      migration temporarily, run `SKIP_PGVECTOR_MIGRATION=true rails db:migrate`
      and re-run later once the image is updated.
    MSG
  end
end
