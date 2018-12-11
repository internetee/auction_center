class AddPaymentOrdersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_orders do |t|
      t.string :type, null: false
      t.integer :invoice_id, null: false
      t.integer :status, null: false
      t.integer :user_id, null: true

      t.timestamps
    end

    add_foreign_key :payment_orders, :invoices
    add_foreign_key :payment_orders, :users

    add_index :payment_orders, :invoice_id
    add_index :payment_orders, :user_id
  end
end
