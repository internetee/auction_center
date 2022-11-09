class AddInitialDateEndsToAuction < ActiveRecord::Migration[6.1]
  def change
    add_column :auctions, :initial_ends_at, :datetime, null: true
  end
end
