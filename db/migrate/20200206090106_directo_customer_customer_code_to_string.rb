class DirectoCustomerCustomerCodeToString < ActiveRecord::Migration[6.0]
  def change
    change_column :directo_customers, :customer_code, :string
  end
end
