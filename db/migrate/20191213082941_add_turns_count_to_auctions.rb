class AddTurnsCountToAuctions < ActiveRecord::Migration[6.0]
  def change
    add_column :auctions, :turns_count, :integer
  end
end
