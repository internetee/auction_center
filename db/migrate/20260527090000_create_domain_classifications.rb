class CreateDomainClassifications < ActiveRecord::Migration[7.0]
  # Per-domain semantic classification. Single source of truth for what a
  # domain *means*, decoupled from any specific auction. See ADR-001.
  #
  # Embeddings are stored as a plain Postgres array of doubles — no
  # pgvector — so this migration runs on the shared dev image and on
  # production RDS without extension setup. Cosine similarity is
  # computed in Ruby at scoring time.
  def change
    create_table :domain_classifications do |t|
      t.string :domain_name, null: false
      t.uuid :uuid, default: 'gen_random_uuid()', null: false

      t.string :primary_category
      t.string :tags, array: true, default: [], null: false
      t.string :keywords, array: true, default: [], null: false

      t.string :audience
      t.string :languages, array: true, default: [], null: false
      t.string :suggested_use_cases, array: true, default: [], null: false

      t.decimal :brandability_score, precision: 4, scale: 3

      t.string :classification_source           # 'heuristic' | 'openai' | 'manual' | 'imported'
      t.string :classification_model
      t.decimal :confidence, precision: 4, scale: 3
      t.datetime :classified_at
      t.jsonb :raw_llm_response, default: {}, null: false

      t.column :embedding, :"double precision[]"
      t.string :embedding_model
      t.datetime :embedded_at

      t.timestamps
    end

    add_index :domain_classifications, :domain_name, unique: true
    add_index :domain_classifications, :uuid, unique: true
    add_index :domain_classifications, :tags, using: :gin
    add_index :domain_classifications, :keywords, using: :gin
    add_index :domain_classifications, :primary_category
    add_index :domain_classifications, :audience
    add_index :domain_classifications, :classified_at
    add_index :domain_classifications, :classification_source
    add_index :domain_classifications, :embedded_at
  end
end
