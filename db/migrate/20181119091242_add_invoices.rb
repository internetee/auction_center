class AddInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :result_id, null: false
      t.integer :user_id, null: true
      t.integer :billing_profile_id, null: true
      t.date :issued_at, null: false
      t.date :payment_at, null: false

      t.timestamps
    end

    add_foreign_key :invoices, :results
    add_foreign_key :invoices, :users
    add_foreign_key :invoices, :billing_profiles

    add_index :invoices, :result_id
    add_index :invoices, :user_id
    add_index :invoices, :billing_profile_id
  end
end
