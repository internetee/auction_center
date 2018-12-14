class RemoveNotNullConstraintOnBillingProfilesUserId < ActiveRecord::Migration[5.2]
  def change
    change_column_null :billing_profiles, :user_id, true
  end
end
