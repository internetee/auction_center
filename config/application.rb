require_relative 'boot'

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AuctionCenter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    # config.autoloader = :classic
    # config.autoloader = :zeitwerk

    config.active_model.i18n_customize_full_message = true
    config.autoload_paths += %W(#{config.root}/app/models/concerns)


    # config.autoload_paths += Dir[Rails.root.join('app', 'presenters', '**/')]
    # config.autoload_paths += Dir[Rails.root.join('app', 'broadcasts', '**/')]
    # config.autoload_paths += Dir[Rails.root.join('app', 'errors', '**/')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Load any YAML file nested under locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    # Schema.rb does not retain information about triggers and schemas that are not public.
    config.active_record.schema_format = :sql

    # Use delayed_job for background processing
    config.active_job.queue_adapter = :delayed_job

    # Load customization from special file
    config.customization = config_for(:customization)

    # Available locales
    config.i18n.available_locales = %i[en et]
    config.i18n.default_locale = config.customization['locale'] || 'en'

    # Default to UTC if not set
    config.time_zone = config.customization['time_zone'] || 'UTC'

    config.action_mailer.delivery_job = 'ActionMailer::MailDeliveryJob'

    config.action_mailer.smtp_settings = {
      address: config.customization.dig(:mailer, :address),
      port: config.customization.dig(:mailer, :port),
      enable_starttls_auto: config.customization.dig(:mailer, :enable_starttls_auto),
      user_name: config.customization.dig(:mailer, :user_name),
      password: config.customization.dig(:mailer, :password),
      authentication: config.customization.dig(:mailer, :authentication),
      domain: config.customization.dig(:mailer, :domain),
      openssl_verify_mode: config.customization.dig(:mailer, :openssl_verify_mode)
    }

    config.action_mailer.default_url_options = {
      host: config.customization.dig(:mailer, :host)
    }
  end
end
