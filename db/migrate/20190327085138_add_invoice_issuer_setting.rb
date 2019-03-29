class AddInvoiceIssuerSetting < ActiveRecord::Migration[5.2]
  def change
    invoice_issuer_description = <<~TEXT.squish
      Text that should appear in invoice as issuer. Usually contains company name, VAT number and
      local court registration number.
    TEXT

    invoice_issuer_value = <<~TEXT.squish
      Eesti Interneti SA Paldiski mnt 80, Tallinn, Harjumaa, 10617 Estonia,
      Reg. no 90010019, VAT number EE101286464
    TEXT

    invoice_issuer_setting = Setting.new(code: :invoice_issuer, value: invoice_issuer_value,
                                   description: invoice_issuer_description)

    invoice_issuer_setting.save
  end

  def down
    Setting.where(code: :invoice_issuer).delete_all
  end
end
