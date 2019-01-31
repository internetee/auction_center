class AddPhoneConfirmationToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.column :mobile_phone_confirmed_at, :datetime, null: true
      t.column :mobile_phone_confirmation_code, :string, null: true
    end
  end
end
