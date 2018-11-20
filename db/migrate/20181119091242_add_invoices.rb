class AddInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :result_id, null: false
      t.integer :user_id, null: true
      t.integer :billing_profile_id, null: true

      t.timestamps
    end
  end
end
