class RenameInvoiceNumberAndGenereNewNumberToInvoice < ActiveRecord::Migration[6.1]
  def change
    rename_column :invoices, :number, :number_old

    add_column :invoices, :number, :integer

    execute "UPDATE invoices SET number = number_old"
  end
end
