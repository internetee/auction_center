class AddStatusAndRefundTimeForDepositAuctions < ActiveRecord::Migration[6.1]
  def change
    add_column :domain_participate_auctions, :status, :integer, null: false, default: 0
    add_column :domain_participate_auctions, :refund_time, :datetime, null: true
  end
end
