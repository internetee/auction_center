class AddBillingProfileIdToOffer < ActiveRecord::Migration[5.2]
  def change
    change_table :offers do |t|
      t.integer :billing_profile_id, null: false
    end
  end
end
