class RemoveUniqueIndexFromVatCode < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    remove_index :billing_profiles, :vat_code
    add_index :billing_profiles, [:vat_code, :user_id], algorithm: :concurrently,
      unique: true
  end
end
