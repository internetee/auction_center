class CreateDomainClassifications < ActiveRecord::Migration[7.0]
  def change
    create_table :domain_classifications do |t|
      t.string :domain_name, null: false
      t.uuid :uuid, default: 'gen_random_uuid()', null: false

      # Categorical signals
      t.string :primary_category
      t.string :tags, array: true, default: [], null: false

      # Description / readable enrichment
      t.text :description
      t.string :description_locale, default: 'en'

      # Semantic tokens
      t.string :keywords, array: true, default: [], null: false

      # Audience / language / use-case hints
      t.string :audience
      t.string :languages, array: true, default: [], null: false
      t.string :suggested_use_cases, array: true, default: [], null: false

      # Cached structural features
      t.boolean :has_digits, default: false, null: false
      t.boolean :has_hyphens, default: false, null: false
      t.integer :token_count
      t.boolean :dictionary_word, default: false, null: false
      t.decimal :brandability_score, precision: 4, scale: 3

      # Provenance
      t.string :classification_source           # 'heuristic' | 'openai' | 'manual' | 'imported'
      t.string :classification_model
      t.decimal :confidence, precision: 4, scale: 3
      t.datetime :classified_at
      t.jsonb :raw_llm_response, default: {}, null: false

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
  end
end
