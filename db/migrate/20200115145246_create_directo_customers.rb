class CreateDirectoCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :directo_customers do |t|
      enable_extension :citext
      t.citext :vat_number, null: false
      t.integer :customer_code, null: false

      t.timestamps
    end
  end
end
