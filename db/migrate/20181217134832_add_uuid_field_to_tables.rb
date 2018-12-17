class AddUuidFieldToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :auctions, :uuid, :uuid, default: 'gen_random_uuid()'
    add_column :billing_profiles, :uuid, :uuid, default: 'gen_random_uuid()'
    add_column :invoices, :uuid, :uuid, default: 'gen_random_uuid()'
    add_column :invoice_items, :uuid, :uuid, default: 'gen_random_uuid()'
    add_column :payment_orders, :uuid, :uuid, default: 'gen_random_uuid()'
    add_column :results, :uuid, :uuid, default: 'gen_random_uuid()'
    add_column :users, :uuid, :uuid, default: 'gen_random_uuid()'
  end
end
