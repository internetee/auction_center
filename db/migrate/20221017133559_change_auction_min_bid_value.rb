class ChangeAuctionMinBidValue < ActiveRecord::Migration[6.1]
  def change
    change_column :auctions, :min_bids_step, :decimal, precision: 5, scale: 2
  end
end
