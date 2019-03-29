class UpdateBillingProfilesVatCode < ActiveRecord::Migration[5.2]
  def up
    BillingProfile.where(vat_code: "").update_all(vat_code: nil)
  end

  def down
    # no-op
  end
end
