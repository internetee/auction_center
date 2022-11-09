class DefaultStartAtColumnOnAuctionSetAsNil < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:auctions, :starts_at, nil)
  end
end
