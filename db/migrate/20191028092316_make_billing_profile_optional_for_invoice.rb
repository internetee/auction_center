class MakeBillingProfileOptionalForInvoice < ActiveRecord::Migration[5.2]
  def up
    # change_column :offers, :billing_profile_id, :integer, null: true
    # change_column :invoices, :billing_profile_id, :integer, null: true
    remove_foreign_key :invoices, :billing_profiles
    add_foreign_key :invoices, :billing_profiles, on_delete: :nullify
  end

  def down
    # change_column :offers, :billing_profile_id, :integer, null: false
    # change_column :invoices, :billing_profile_id, :integer, null: false
    remove_foreign_key :invoices, :billing_profiles
    add_foreign_key :invoices, :billing_profiles
  end
end
