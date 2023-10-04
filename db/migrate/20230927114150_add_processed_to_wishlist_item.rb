class AddProcessedToWishlistItem < ActiveRecord::Migration[7.0]
  def change
    add_column :wishlist_items, :processed, :boolean, default: false
  end
end
