namespace :data_migrations do
  desc "Create remind on domain registration every day setting"
  task remind_on_domain_registration_everyday_setting: :environment do

    Setting.transaction do
      remind_everyday_description = <<~TEXT.squish
        Shall system send registration reminders on paid but not registered domains every day.
        Can be either 'true' or 'false'
      TEXT

      remind_on_domain_registration_everyday = Setting.new(code: :remind_on_domain_registration_everyday,
                                                           value: 'false',
                                                           value_format: 'boolean',
                                                           description: remind_everyday_description)

      remind_on_domain_registration_everyday.save!
      puts "Remind on domain registration every day setting updated"
    end
  end
end
