class AddPhoneConfirmationToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.column :phone_number_confirmed_at, :datetime, null: true
      t.column :phone_number_confirmation_code, :string, null: true
    end
  end
end
