class AddVatNumberAndPaidAmountToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :vat_rate, :decimal
    add_column :invoices, :total_amount, :decimal
  end
end
