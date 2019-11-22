namespace :data_migrations do
  desc 'Creates settings to fetch shared footer from VOOG site'
  task create_shared_footer_fetcher_settings: :environment do
    hash = {
      voog_site_url: {
        description: <<~TEXT.squish,
          VOOG site from which to fetch localized footer elements. Defaults to https://www.internet.ee.
        TEXT
        value: 'https://www.internet.ee',
      },
      voog_api_key: {
        description: <<~TEXT.squish,
          VOOG site API key. Required to fetch footer content.
        TEXT
        value: 'changeme',
      },
      voog_site_fetching_enabled: {
        description: <<~TEXT.squish,
          Boolean whether to enable fetching & showing footer element from VOOG site. Defaults to false.
        TEXT
        value: 'false',
      },
    }

    Setting.transaction do
      hash.each do |key, value_hash|
        setting = Setting.find_or_create_by(code: key)
        setting.update!(value: value_hash[:value], description: value_hash[:description])
      end
      puts 'VOOG site fetching settings are set'
    end
  end
end
