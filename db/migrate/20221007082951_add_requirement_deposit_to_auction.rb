class AddRequirementDepositToAuction < ActiveRecord::Migration[6.1]
  def change
    add_column :auctions, :requirement_deposit_in_cents, :integer, null: true
  end
end
