class AddOffersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.integer :auction_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_foreign_key :offers, :auctions
    add_foreign_key :offers, :users
  end
end
