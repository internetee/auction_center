OpenAI.configure do |config|
  config.access_token = AuctionCenter::Application.config.customization.dig(:openai, :access_token)
  config.organization_id = AuctionCenter::Application.config.customization.dig(:openai, :organization_id) # Optional
  # config.uri_base = "https://oai.hconeai.com/" # Optional
  config.request_timeout = 240 # Optional
  config.log_errors = true
end
