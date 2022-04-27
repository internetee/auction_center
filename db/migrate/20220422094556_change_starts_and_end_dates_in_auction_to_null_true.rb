class ChangeStartsAndEndDatesInAuctionToNullTrue < ActiveRecord::Migration[6.1]
  def change
    change_column_null :auctions, :starts_at, :true
    change_column_null :auctions, :ends_at, :true
  end
end
