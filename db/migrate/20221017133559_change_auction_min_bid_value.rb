class ChangeAuctionMinBidValue < ActiveRecord::Migration[6.1]
  def up
    change_column :auctions, :min_bids_step, :decimal, precision: 10, scale: 2
  end

  def down
    change_column :auctions, :min_bids_step, :decimal
  end
end
