class CreateRecommendationTables < ActiveRecord::Migration[7.0]
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

    create_table :recommendation_events do |t|
      t.references :user, foreign_key: true
      t.references :auction, foreign_key: true
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :event_type, null: false
      t.string :source
      t.string :session_id
      t.string :request_id
      t.datetime :occurred_at, null: false
      t.jsonb :properties, default: {}, null: false

      t.timestamps
    end

    add_index :recommendation_events, :uuid, unique: true
    add_index :recommendation_events, :event_type
    add_index :recommendation_events, :occurred_at
    add_index :recommendation_events, %i[user_id event_type occurred_at], name: 'idx_rec_events_user_type_time'
    add_index :recommendation_events, :properties, using: :gin

    # `scorer_name` (not `model_name`) — Rails 8.1 reserves `model_name`
    # as a class method on ActiveRecord, and using it as a column raises
    # ActiveRecord::DangerousAttributeError when records are loaded.
    create_table :user_auction_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.references :auction, null: false, foreign_key: true
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.decimal :score, precision: 10, scale: 6, null: false
      t.string :scorer_name
      t.string :features_version
      t.datetime :calculated_at, null: false

      t.timestamps
    end

    add_index :user_auction_scores, :uuid, unique: true
    add_index :user_auction_scores, %i[user_id auction_id], unique: true
    add_index :user_auction_scores, %i[user_id score]
  end
end
