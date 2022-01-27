class ChangeDefaultNumberValueToInvoice < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:invoices, :number, nil)
  end
end
