class AddResultsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.integer :auction_id, null: false
      t.integer :user_id, null: true
      t.integer :final_price_in_cents, null: true
      t.boolean :sold, null: false

      t.timestamps
    end

    add_foreign_key :results, :auctions
  end
end
