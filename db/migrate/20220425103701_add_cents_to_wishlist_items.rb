class AddCentsToWishlistItems < ActiveRecord::Migration[6.1]
  def change
    add_column :wishlist_items, :cents, :integer
  end
end
