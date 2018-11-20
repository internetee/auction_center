class AddResultsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.integer :auction_id, null: false
      t.integer :user_id, null: true
      t.integer :offer_id, null: true
      t.integer :cents, null: true
      t.boolean :sold, null: false

      t.timestamps
    end

    add_foreign_key :results, :auctions
    add_index :results, :offer_id
    add_index :results, :user_id
    add_index :results, :auction_id
  end
end
