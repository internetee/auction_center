class AddInDirectoToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :in_directo, :boolean, null: false, default: false
  end
end
