class AddWishlistItemsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :wishlist_items do |t|
      t.string :domain_name, null: false
      t.integer :user_id, null: false
      t.datetime :valid_until, null: false, default: -> { "now() + interval '2 years'" }
      t.uuid :uuid, default: 'gen_random_uuid()'

      t.timestamps
    end

    add_foreign_key :wishlist_items, :users
    add_index :wishlist_items, :domain_name
  end
end
