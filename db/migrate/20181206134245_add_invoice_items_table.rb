class AddInvoiceItemsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.string :name, null: false
      t.integer :cents, null: false

      t.timestamps
    end

    add_foreign_key :invoice_items, :invoices
    add_index :invoice_items, :invoice_id
  end
end
