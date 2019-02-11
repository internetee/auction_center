class RemoveMobilePhoneNullConstraint < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :mobile_phone, true
  end
end
