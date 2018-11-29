class MoveResultFieldsToInvoice < ActiveRecord::Migration[5.2]
  def change
    change_table :invoices do |t|
      t.integer :cents, null: false
    end

    remove_column :results, :cents, :integer
    remove_column :results, :billing_profile_id, :integer
  end
end
