# frozen_string_literal: true

class ModifyInvoiceIssuerData < ActiveRecord::Migration[7.0]
  def up
    hash = {
      invoice_issuer: {
        description: <<~TEXT.squish,
          Text that should appear in invoice as issuer. Usually contains a company name.
        TEXT
        value: 'Eesti Interneti SA',
        value_format: 'string'
      },
      invoice_issuer_reg_no: {
        description: <<~TEXT.squish,
          Invoice issuer registration number
        TEXT
        value: '90010019',
        value_format: 'string'
      },
      invoice_issuer_vat_no: {
        description: <<~TEXT.squish,
          Invoice issuer VAT number.
        TEXT
        value: 'EE101286464',
        value_format: 'string'
      },
      invoice_issuer_street: {
        description: <<~TEXT.squish,
          Invoice issuer street name.
        TEXT
        value: 'Paldiski mnt 80',
        value_format: 'string'
      },
      invoice_issuer_state: {
        description: <<~TEXT.squish,
          Invoice issuer state name.
        TEXT
        value: 'Harjumaa',
        value_format: 'string'
      },
      invoice_issuer_zip: {
        description: <<~TEXT.squish,
          Invoice issuer zip code.
        TEXT
        value: '10617',
        value_format: 'string'
      },
      invoice_issuer_city: {
        description: <<~TEXT.squish,
          Invoice issuer city name.
        TEXT
        value: 'Tallinn',
        value_format: 'string'
      },
      invoice_issuer_country_code: {
        description: <<~TEXT.squish,
          Invoice issuer country code.
        TEXT
        value: 'EE',
        value_format: 'string'
      }
    }

    Setting.transaction do
      hash.each do |key, value_hash|
        setting = Setting.find_or_create_by(code: key)
        setting.update!(value: value_hash[:value],
                        description: value_hash[:description],
                        value_format: value_hash[:value_format])
      end
      puts 'Invoice issuer settings updated.'
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
