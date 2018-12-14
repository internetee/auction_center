class AddBillingProfileIdToResult < ActiveRecord::Migration[5.2]
  def change
    change_table :results do |t|
      t.integer :billing_profile_id, null: true
    end
  end
end
