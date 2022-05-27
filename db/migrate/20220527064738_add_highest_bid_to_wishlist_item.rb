class AddHighestBidToWishlistItem < ActiveRecord::Migration[6.1]
  def change
    add_column :wishlist_items, :highest_bid, :integer
  end
end
