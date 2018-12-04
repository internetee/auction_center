class AddInvoiceStatuses < ActiveRecord::Migration[5.2]
  def change
    change_table :invoices do |t|
      t.integer :status, default: 0, null: false
    end
  end
end
