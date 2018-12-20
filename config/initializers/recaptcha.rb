Recaptcha.configure do |config|
  config.site_key = AuctionCenter::Application.config.customization.dig('recaptcha', 'site_key')
  config.secret_key = AuctionCenter::Application.config.customization.dig('recaptcha', 'secret_key')
end
