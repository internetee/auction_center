namespace :data_migrations do
  desc "Create remind on domain registration every day setting"
  task remind_on_domain_registration_everyday_setting: :environment do

    Setting.transaction do
      remind_everyday_description = <<~TEXT.squish
        Days remaining to the registration deadline that triggers daily reminder email until
        deadline is reached or domain is registered. This is in addition
        to domain_registration_reminder setting that send reminder just once. Default: 0
      TEXT

      remind_on_domain_registration_everyday = Setting.new(code: :domain_registration_daily_reminder,
                                                           value: '0',
                                                           value_format: 'integer',
                                                           description: remind_everyday_description)

      remind_on_domain_registration_everyday.save!
      puts "Remind on domain registration every day setting updated"
    end
  end
end
