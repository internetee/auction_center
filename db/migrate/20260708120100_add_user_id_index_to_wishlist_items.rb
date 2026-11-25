class AddUserIdIndexToWishlistItems < ActiveRecord::Migration[8.1]
  # wishlist_items(user_id) was unindexed. The recommendation hot paths query a
  # user's wishlist on every /auctions load (Auction::UserSortable) and during
  # per-user scoring (Recommendation::Scorer), so index the lookup column.
  def change
    add_index :wishlist_items, :user_id
  end
end
