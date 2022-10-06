class AddEnableDepositToAuctions < ActiveRecord::Migration[6.1]
  def change
    add_column :auctions, :enable_deposit, :boolean, null: false, default: false
  end
end
