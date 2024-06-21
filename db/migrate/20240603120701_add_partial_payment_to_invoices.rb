class AddPartialPaymentToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :partial_payments, :boolean, default: false
  end
end
