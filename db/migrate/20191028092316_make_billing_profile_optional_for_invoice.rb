class MakeBillingProfileOptionalForInvoice < ActiveRecord::Migration[5.2]
  def up
    remove_foreign_key :invoices, :billing_profiles
    add_foreign_key :invoices, :billing_profiles, on_delete: :nullify
  end

  def down
    remove_foreign_key :invoices, :billing_profiles
    add_foreign_key :invoices, :billing_profiles
  end
end
