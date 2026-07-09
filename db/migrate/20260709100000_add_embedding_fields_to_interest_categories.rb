class AddEmbeddingFieldsToInterestCategories < ActiveRecord::Migration[7.0]
  # v3 unified embedding space: an interest category becomes "like a domain".
  # We enrich it with an LLM description + keywords, then embed that text into
  # the same 1536-dim space as domains so a selected category can act as a
  # magnet the same way a bid/wishlist domain does.
  # See docs/planning/recommendation-v3-unified-embedding-plan.md.
  def change
    add_column :interest_categories, :description, :text
    add_column :interest_categories, :keywords, :string, array: true, default: [], null: false
    add_column :interest_categories, :embedding, :float, array: true
    add_column :interest_categories, :embedding_model, :string
    add_column :interest_categories, :embedded_at, :datetime

    add_index :interest_categories, :embedded_at
  end
end
