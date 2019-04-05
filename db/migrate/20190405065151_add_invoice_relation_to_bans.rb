class AddInvoiceRelationToBans < ActiveRecord::Migration[5.2]
  def change
    change_table :bans do |t|
      t.integer :invoice_id, null: true
    end

    add_index :bans, :invoice_id
  end
end
