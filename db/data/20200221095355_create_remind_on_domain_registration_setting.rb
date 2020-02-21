class CreateRemindOnDomainRegistrationSetting < ActiveRecord::Migration[6.0]
  def up
    Setting.transaction do
      remind_everyday_description = <<~TEXT.squish
        Days remaining to the registration deadline that triggers daily reminder email until
        deadline is reached or domain is registered. This is in addition
        to domain_registration_reminder setting that send reminder just once. Default: 0
      TEXT
      value = '0'

      setting = Setting.find_or_create_by(code: :domain_registration_daily_reminder)
      return if setting.value.present?

      setting.update(value: value,
                     description: remind_everyday_description,
                     value_format: 'integer')
      puts "Remind on domain registration every day setting updated"
    end
  end

  def down
  end
end
