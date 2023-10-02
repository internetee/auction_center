class AddInvoiceIssuerSeparateInformations < ActiveRecord::Migration[7.0]
  def change
    # Default issuer address
    invoice_issuer_address_description = <<~TEXT.squish
      Default issuer address
    TEXT

    invoice_issuer_address_value = <<~TEXT.squish
      Paldiski mnt 80, Tallinn, Harjumaa, 10617 Estonia,
    TEXT

    invoice_issuer_address_setting = Setting.new(code: :invoice_issuer_address, value: invoice_issuer_address_value,
                                                 description: invoice_issuer_address_description,
                                                 value_format: 'string')

    invoice_issuer_address_setting.save

    # Default issuer reg no
    invoice_issuer_reg_no_description = <<~TEXT.squish
      Default issuer reg no
    TEXT

    invoice_issuer_reg_no_value = <<~TEXT.squish
      90010019
    TEXT

    invoice_issuer_reg_no_setting = Setting.new(code: :invoice_issuer_reg_no, value: invoice_issuer_reg_no_value,
                                                description: invoice_issuer_reg_no_description,
                                                value_format: 'string')

    invoice_issuer_reg_no_setting.save

    # Default issuer vat number
    invoice_issuer_vat_no_description = <<~TEXT.squish
      Default issuer vat number
    TEXT

    invoice_issuer_vat_no_value = <<~TEXT.squish
      EE101286464
    TEXT

    invoice_issuer_vat_no_setting = Setting.new(code: :invoice_issuer_vat_number, value: invoice_issuer_vat_no_value,
                                                description: invoice_issuer_vat_no_description,
                                                value_format: 'string')

    invoice_issuer_vat_no_setting.save

    # Default organization phone
    default_organization_phone_description = <<~TEXT.squish
      Default organization phone
    TEXT
    default_organization_phone_value = '+372 727 1000'
    default_organization_phone_setting = Setting.new(code: :organization_phone,
                                                     value: default_organization_phone_value,
                                                     description: default_organization_phone_description,
                                                     value_format: 'string')
    default_organization_phone_setting.save
  end

  def down
    Setting.where(code: :invoice_issuer_address).delete_all
    Setting.where(code: :invoice_issuer_reg_no).delete_all
    Setting.where(code: :invoice_issuer_vat_number).delete_all
    Setting.where(code: :organization_phone).delete_all
  end
end
