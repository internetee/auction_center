class CreateDirectoSettings < ActiveRecord::Migration[6.0]
  def up
    hash = {
      directo_integration_enabled: {
        description: <<~TEXT.squish,
          Enables or disables Directo Integration. Allowed values true / false. Defaults to false.
        TEXT
        value: 'false',
        value_format: 'boolean'
      },
      directo_api_url: {
        description: <<~TEXT.squish,
          API URL for Directo backend
        TEXT
        value: 'http://directo.test',
        value_format: 'string'
      },
      directo_sales_agent: {
        description: <<~TEXT.squish,
          Directo SalesAgent value. Retrieve it from Directo.
        TEXT
        value: 'AUCTION',
        value_format: 'string'
      },
      directo_default_payment_terms: {
        description: <<~TEXT.squish,
          Default payment term for creating invoices for Directo. Defaults to net10
        TEXT
        value: 'R',
        value_format: 'string'
      }
    }

    Setting.transaction do
      hash.each do |key, value_hash|
        setting = Setting.find_or_create_by(code: key)
        next if setting.value.present?

        setting.update!(value: value_hash[:value],
                        description: value_hash[:description],
                        value_format: value_hash[:value_format])
      end
      puts 'Directo integration settings are initialized.'
    end
  end

  def down
  end
end
