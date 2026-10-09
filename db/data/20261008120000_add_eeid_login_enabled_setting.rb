# frozen_string_literal: true

class AddEeidLoginEnabledSetting < ActiveRecord::Migration[8.0]
  def up
    setting = Setting.find_or_initialize_by(code: 'eeid_login_enabled')
    return if setting.persisted?

    setting.update!(value: 'false',
                    value_format: 'boolean',
                    description: <<~TEXT.squish)
                      Sign in with an identity document through eeID instead of TARA.
                      Can be either 'true' or 'false'. Switch back to 'false' to fall back to TARA.
                    TEXT
  end

  # VERSION=20261008120000 rake db:migrate:down:with_data
  def down
    Setting.find_by(code: 'eeid_login_enabled')&.destroy
  end
end
