class RemoveEndsAtIndexFromAuctions < ActiveRecord::Migration[6.1]
  def change
    remove_index :auctions, :ends_at
  end
end
