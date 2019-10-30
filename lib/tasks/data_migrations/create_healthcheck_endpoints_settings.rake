namespace :data_migrations do
  desc 'Seeds API, Tara & SMS healthcheck endpoints'
  task create_healthcheck_endpoint_settings: :environment do

    hash = {
      check_api_url: {
        description: <<~TEXT.squish,
          URL to our own auction API endpoint for health checking.
          Must be absolute, default is http://localhost/auctions.json.
        TEXT
        value: 'http://localhost/auctions.json',
      },
      check_sms_url: {
        description: <<~TEXT.squish,
          URL of SMS service provider for health checking.
          Must be absolute.
        TEXT
        value: 'https://status.messente.com/api/v1/components/1',
      },
      check_tara_url: {
        description: <<~TEXT.squish,
          URL of OAUTH Tara provider for health checking.
          Must be absolute.
        TEXT
        value: 'https://tara-test.ria.ee/oidc/jwks',
      },
    }

    Setting.transaction do
      hash.each do |key, value_hash|
        setting = Setting.find_or_create_by(code: key)
        setting.update!(value: value_hash[:value], description: value_hash[:description])
      end
      puts "Healthcheck API endpoints settings are set"
    end
  end
end
