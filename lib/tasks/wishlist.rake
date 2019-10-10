namespace :wishlist do
  desc 'Populate settings with wishlist domain extension ruleset'
  task 'create_extension_settings' => :environment do
    # Wishlist supported domain extensions
    domain_extensions_description = <<~TEXT.squish
      Supported domain extensions for wishlist domain monitoring.
    TEXT

    extensions = ['ee', 'pri.ee', 'com.ee', 'med.ee', 'fie.ee']
    domain_extensions = Setting.new(
      code: :wishlist_supported_domain_extensions,
      value: extensions,
      description: domain_extensions_description
    )
    puts 'Successfully saved domain extensions' if domain_extensions.save

    # Wishlist default domain extension
    default_domain_extension_description = <<~TEXT.squish
      Used to autocomplete domain name in order to get FQDN, if not present
    TEXT

    default_domain_extension = Setting.new(
      code: :default_domain_extension,
      value: 'ee',
      description: default_domain_extension_description
    )
    puts 'Successfully saved default domain extension' if default_domain_extension.save
  end
end