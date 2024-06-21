class UpdateInvoicePaidAmountDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :invoices, :paid_amount, from: nil, to: 0
  end
end
