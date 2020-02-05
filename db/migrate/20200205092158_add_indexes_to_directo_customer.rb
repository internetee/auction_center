class AddIndexesToDirectoCustomer < ActiveRecord::Migration[6.0]
  def change
    add_index :directo_customers, :vat_number, unique: true
    add_index :directo_customers, :customer_code, unique: true
  end
end
