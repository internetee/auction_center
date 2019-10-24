namespace :data_migrations do
  desc 'Populate settings with wishlist domain extension whitelist'
  task 'create_extension_whitelist' => :environment do
    domain_extensions_description = <<~TEXT.squish
      Supported domain extensions for wishlist domain monitoring.
    TEXT

    extensions = ['ee', 'pri.ee', 'com.ee', 'med.ee', 'fie.ee']
    domain_extensions = Setting.new(
      code: :wishlist_supported_domain_extensions,
      value: extensions,
      description: domain_extensions_description
    )
    domain_extensions.save!
  end
end
