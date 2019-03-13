class AddRegistrationReminderSetting < ActiveRecord::Migration[5.2]
  def up
    domain_registration_description = <<~TEXT.squish
      Number of days before which the registration reminder email is sent on. Default: 5
    TEXT

    domain_registration_setting = Setting.new(code: :domain_registration_reminder, value: '5',
                                              description: domain_registration_description)

    domain_registration_setting.save
  end

  def down
    Seting.find_by(code: :domain_registration_reminder).delete
  end
end
