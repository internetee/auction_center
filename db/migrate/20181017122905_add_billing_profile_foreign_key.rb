class AddBillingProfileForeignKey < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :billing_profiles, :users
  end
end
