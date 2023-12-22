class UpdateInvoiceIssuerInfo < ActiveRecord::Migration[7.0]
  def up
    # Default invoice issuer
    invoice_issuer_description = <<~TEXT.squish
      Text that should appear in invoice as issuer. Usually contains a company name.
    TEXT

    invoice_issuer_value = <<~TEXT.squish
      Eesti Interneti SA
    TEXT

    invoice_issuer_setting = Setting.find_by(code: :invoice_issuer)

    invoice_issuer_setting.update(value: invoice_issuer_value,
                                  description: invoice_issuer_description)

    # Default invoice issuer registration no
    invoice_issuer_reg_no_description = <<~TEXT.squish
      Invoice issuer registration number.
    TEXT

    invoice_issuer_reg_no_value = <<~TEXT.squish
      90010019
    TEXT

    invoice_issuer_reg_no_setting = Setting.new(code: :invoice_issuer_reg_no, value: invoice_issuer_reg_no_value,
                                                description: invoice_issuer_reg_no_description,
                                                value_format: 'string')

    invoice_issuer_reg_no_setting.save

    # Default invoice issuer VAT no
    invoice_issuer_vat_no_description = <<~TEXT.squish
      Invoice issuer VAT number.
    TEXT

    invoice_issuer_vat_no_value = <<~TEXT.squish
      EE101286464
    TEXT

    invoice_issuer_vat_no_setting = Setting.new(code: :invoice_issuer_vat_no, value: invoice_issuer_vat_no_value,
                                                description: invoice_issuer_vat_no_description,
                                                value_format: 'string')

    invoice_issuer_vat_no_setting.save

    # Default invoice issuer street name
    invoice_issuer_street_description = <<~TEXT.squish
      Invoice issuer street name.
    TEXT

    invoice_issuer_street_value = <<~TEXT.squish
      Paldiski mnt 80
    TEXT

    invoice_issuer_street_setting = Setting.new(code: :invoice_issuer_street, value: invoice_issuer_street_value,
                                                description: invoice_issuer_street_description,
                                                value_format: 'string')

    invoice_issuer_street_setting.save

    # Default invoice issuer state name
    invoice_issuer_state_description = <<~TEXT.squish
      Invoice issuer state name.
    TEXT

    invoice_issuer_state_value = <<~TEXT.squish
      Harjumaa
    TEXT

    invoice_issuer_state_setting = Setting.new(code: :invoice_issuer_state, value: invoice_issuer_state_value,
                                               description: invoice_issuer_state_description,
                                               value_format: 'string')

    invoice_issuer_state_setting.save

    # Default invoice issuer postal code
    invoice_issuer_zip_description = <<~TEXT.squish
      Invoice issuer zip code.
    TEXT

    invoice_issuer_zip_value = <<~TEXT.squish
      10617
    TEXT

    invoice_issuer_zip_setting = Setting.new(code: :invoice_issuer_zip, value: invoice_issuer_zip_value,
                                             description: invoice_issuer_zip_description,
                                             value_format: 'string')

    invoice_issuer_zip_setting.save

    # Default invoice issuer city name
    invoice_issuer_city_description = <<~TEXT.squish
      Invoice issuer city name.
    TEXT

    invoice_issuer_city_value = <<~TEXT.squish
      Tallinn
    TEXT

    invoice_issuer_city_setting = Setting.new(code: :invoice_issuer_city, value: invoice_issuer_city_value,
                                              description: invoice_issuer_city_description,
                                              value_format: 'string')

    invoice_issuer_city_setting.save

    # Default invoice issuer country code
    invoice_issuer_country_code_description = <<~TEXT.squish
      Invoice issuer country code.
    TEXT

    invoice_issuer_country_code_value = <<~TEXT.squish
      EE
    TEXT

    invoice_issuer_country_code_setting = Setting.new(code: :invoice_issuer_country_code, value: invoice_issuer_country_code_value,
                                                      description: invoice_issuer_country_code_description,
                                                      value_format: 'string')

    invoice_issuer_country_code_setting.save
  end

  def down
    Setting.find_by(code: :invoice_issuer_reg_no).delete
    Setting.find_by(code: :invoice_issuer_vat_no).delete
    Setting.find_by(code: :invoice_issuer_street).delete
    Setting.find_by(code: :invoice_issuer_state).delete
    Setting.find_by(code: :invoice_issuer_zip).delete
    Setting.find_by(code: :invoice_issuer_city).delete
    Setting.find_by(code: :invoice_issuer_country_code).delete
  end
end
