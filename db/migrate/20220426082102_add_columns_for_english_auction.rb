class AddColumnsForEnglishAuction < ActiveRecord::Migration[6.1]
  def change
    add_column :auctions, :starting_price, :decimal, null: true
    add_column :auctions, :min_bids_step, :decimal, null: true
    add_column :auctions, :slipping_end, :integer, null: true
  end
end
