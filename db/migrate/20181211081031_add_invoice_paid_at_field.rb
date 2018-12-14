class AddInvoicePaidAtField < ActiveRecord::Migration[5.2]
  def change
    change_table :invoices do |t|
      t.datetime :paid_at, null: true
    end
  end
end
