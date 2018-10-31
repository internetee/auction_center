class MakeBillingProfileCountryCodeAnAlphaTwo < ActiveRecord::Migration[5.2]
  def change
    change_table :billing_profiles do |t|
      t.remove :country
      t.string :alpha_two_country_code, limit: 2, null: false
    end
  end
end
