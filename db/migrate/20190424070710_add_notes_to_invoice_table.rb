class AddNotesToInvoiceTable < ActiveRecord::Migration[5.2]
  def change
    change_table :invoices do |t|
      t.string :notes, null: true
    end
  end
end
