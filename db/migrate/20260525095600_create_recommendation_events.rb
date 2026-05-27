class CreateRecommendationEvents < ActiveRecord::Migration[7.0]
  def change
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
  end
end
