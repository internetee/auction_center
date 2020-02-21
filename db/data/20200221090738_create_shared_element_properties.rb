class CreateSharedElementProperties < ActiveRecord::Migration[6.0]
  def up
    hash = {
      voog_site_url: {
        description: <<~TEXT.squish,
          VOOG site from which to fetch localized footer elements. Defaults to https://www.internet.ee.
        TEXT
        value: 'https://www.internet.ee',
        value_format: 'string',
      },
      voog_api_key: {
        description: <<~TEXT.squish,
          VOOG site API key. Required to fetch footer content.
        TEXT
        value: 'changeme',
        value_format: 'string',
      },
      voog_site_fetching_enabled: {
        description: <<~TEXT.squish,
          Boolean whether to enable fetching & showing footer element from VOOG site. Defaults to false.
        TEXT
        value: 'false',
        value_format: 'boolean',
      },
    }

    Setting.transaction do
      hash.each do |key, value_hash|
        setting = Setting.find_or_create_by(code: key)
        setting.update!(value: value_hash[:value],
                        description: value_hash[:description],
                        value_format: value_hash[:value_format])
      end
      puts 'VOOG site fetching settings are set'
    end
  end

  def down
  end
end
