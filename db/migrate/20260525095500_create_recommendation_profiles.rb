class CreateRecommendationProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :recommendation_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :preferred_tlds, array: true, default: [], null: false
      t.string :interest_keywords, array: true, default: [], null: false
      t.string :preferred_platforms, array: true, default: [], null: false
      t.integer :preferred_length_min
      t.integer :preferred_length_max
      t.integer :budget_min_cents
      t.integer :budget_max_cents
      t.boolean :allow_numbers
      t.boolean :allow_hyphens
      t.datetime :completed_at
      t.datetime :prompt_dismissed_at
      t.datetime :last_prompted_at
      t.integer :prompt_shown_count, default: 0, null: false

      t.timestamps
    end

    add_index :recommendation_profiles, :uuid, unique: true
    add_index :recommendation_profiles, :preferred_tlds, using: :gin
    add_index :recommendation_profiles, :interest_keywords, using: :gin
    add_index :recommendation_profiles, :preferred_platforms, using: :gin
  end
end
