class CreateUserAuctionScores < ActiveRecord::Migration[7.0]
  def change
    create_table :user_auction_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.references :auction, null: false, foreign_key: true
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.decimal :score, precision: 10, scale: 6, null: false
      t.string :model_name
      t.string :features_version
      t.datetime :calculated_at, null: false

      t.timestamps
    end

    add_index :user_auction_scores, :uuid, unique: true
    add_index :user_auction_scores, %i[user_id auction_id], unique: true
    add_index :user_auction_scores, %i[user_id score]
  end
end
