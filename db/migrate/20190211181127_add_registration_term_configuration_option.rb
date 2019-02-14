class AddRegistrationTermConfigurationOption < ActiveRecord::Migration[5.2]
  def up
    registration_term_description = <<~TEXT.squish
      Number of days before the auctioned domain must be registered, starting from
      the auction start. Default: 14
    TEXT

    registration_term_setting = Setting.new(code: :registration_term, value: '14',
                                   description: registration_term_description)

    registration_term_setting.save
  end

  def down
    Setting.where(code: :registration_term).delete_all
  end
end
