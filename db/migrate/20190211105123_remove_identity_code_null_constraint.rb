class RemoveIdentityCodeNullConstraint < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :identity_code, true
  end
end
