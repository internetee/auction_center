Rails.application.config.to_prepare do
  c = Rails.configuration.customization
  VoogFooter.configure do |config|
    config.site_url = c[:voog_site_url].presence || 'https://www.internet.ee'
    config.api_key = c[:voog_api_key].presence
    config.enabled = ActiveModel::Type::Boolean.new.cast(c.fetch(:voog_site_fetching_enabled, 'false'))
    config.cache_ttl = c.fetch(:voog_footer_cache_ttl, '3600').to_i
    config.ssl_verify = if c[:voog_ssl_verify].present?
                          ActiveModel::Type::Boolean.new.cast(c[:voog_ssl_verify])
                        else
                          Rails.env.production? || Rails.env.staging?
                        end
    config.cache_store = Rails.cache
    config.locales = %w[en et]
  end
end
