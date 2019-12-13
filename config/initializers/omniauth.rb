OpenIDConnect.logger = Rails.logger
OpenIDConnect.debug!

OpenIDConnect.http_config do |config|
  config.proxy  = AuctionCenter::Application.config.customization.dig(:tara, :proxy)
end

OmniAuth.config.logger = Rails.logger
# Block GET requests to avoid exposing self to CVE-2015-9284
OmniAuth.config.allowed_request_methods = [:post]

signing_keys = AuctionCenter::Application.config.customization.dig(:tara, :keys).to_json
issuer = AuctionCenter::Application.config.customization.dig(:tara, :issuer)
host = AuctionCenter::Application.config.customization.dig(:tara, :host)
identifier = AuctionCenter::Application.config.customization.dig(:tara, :identifier)
secret = AuctionCenter::Application.config.customization.dig(:tara, :secret)
redirect_uri = AuctionCenter::Application.config.customization.dig(:tara, :redirect_uri)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider "tara", {
    name: 'tara',
    scope: ['openid'],
    state: Proc.new{ SecureRandom.hex(10) },
    client_signing_alg: :RS256,
    client_jwk_signing_key: signing_keys,
    send_scope_to_token_endpoint: false,
    send_nonce: true,
    issuer: issuer,

    client_options: {
      scheme: 'https',
      host: host,

      authorization_endpoint: '/oidc/authorize',
      token_endpoint: '/oidc/token',
      userinfo_endpoint: nil, # Not implemented
      jwks_uri: '/oidc/jwks',

      # Auction
      identifier: identifier,
      secret: secret,
      redirect_uri: redirect_uri,
    },
  }
end
