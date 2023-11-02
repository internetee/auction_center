# frozen_string_literal: true

class AddLHVConnectSettingsValue < ActiveRecord::Migration[7.0]
  def up
    hash = {
      auction_bank_code: {
        description: <<~TEXT.squish,
          Bank code of the account that should appear in invoice as issuer.
        TEXT
        value: '689',
        value_format: 'string'
      },
      auction_iban: {
        description: <<~TEXT.squish,
          IBAN of the account that should appear in invoice as issuer.
        TEXT
        value: 'EE557700771000598731',
        value_format: 'string'
      },
    }

    Setting.transaction do
      hash.each do |key, value_hash|
        setting = Setting.find_or_create_by(code: key)
        setting.update!(value: value_hash[:value],
                        description: value_hash[:description],
                        value_format: value_hash[:value_format])
      end

      Rails.logger.info 'Invoice issuer settings updated.'
    end
  end

  # VERSION=20231102091939 rake db:migrate:down:with_data
  def down
    Setting.transaction do
      Setting.find_by(code: 'auction_bank_code')&.destroy
      Setting.find_by(code: 'auction_iban')&.destroy
    end
  end
end
