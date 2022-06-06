class RemoveHighestBidFromWishlist < ActiveRecord::Migration[6.1]
  def change
    remove_column :wishlist_items, :highest_bid, :integer
  end
end
