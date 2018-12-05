class RenameInvoiceDateFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :invoices, :issued_at, :issue_date
    rename_column :invoices, :payment_at, :due_date
  end
end
