class AddRemoteIdToAuction < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :auctions, :remote_id, :string
    add_index :auctions, :remote_id, unique: true, algorithm: :concurrently
  end
end
