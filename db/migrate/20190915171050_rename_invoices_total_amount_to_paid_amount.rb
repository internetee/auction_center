class RenameInvoicesTotalAmountToPaidAmount < ActiveRecord::Migration[5.2]
  def change
    rename_column :invoices, :total_amount, :paid_amount
  end
end
