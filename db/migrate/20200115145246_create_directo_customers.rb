class CreateDirectoCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :directo_customers do |t|
      t.string :vat_number
      t.integer :customer_code

      t.timestamps
    end
  end
end
