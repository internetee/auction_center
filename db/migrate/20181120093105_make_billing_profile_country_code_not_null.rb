class MakeBillingProfileCountryCodeNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :billing_profiles, :alpha_two_country_code, false
  end
end
