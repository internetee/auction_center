class AddTermsAndConditionsFieldToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.column :terms_and_conditions_accepted_at, :datetime, null: true
    end
  end
end
