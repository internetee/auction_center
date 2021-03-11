module Patches
  module Airbrake
    module SyncSender
      def build_https(uri)
        super.tap do |req|
          req.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    end
  end
end

Airbrake::SyncSender.prepend(::Patches::Airbrake::SyncSender)

Airbrake.configure do |config|
  config.host = Rails.application.config.customization.dig(:airbrake, :host)
  config.project_id = Rails.application.config.customization.dig(:airbrake, :project_id)
  config.project_key = Rails.application.config.customization.dig(:airbrake, :project_key)

  config.environment = Rails.application.config.customization.dig(:airbrake, :environment) || Rails.env
  config.ignore_environments = %w(development test)

  config.blocklist_keys = [:password, :password_confirmation, 'password', 'password_confirmation']
end
