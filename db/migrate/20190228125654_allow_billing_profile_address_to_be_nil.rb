class AllowBillingProfileAddressToBeNil < ActiveRecord::Migration[5.2]
  def change
    change_column_null :billing_profiles, :street, true
    change_column_null :billing_profiles, :city, true
    change_column_null :billing_profiles, :postal_code, true
  end
end
