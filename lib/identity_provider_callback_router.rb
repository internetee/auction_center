# frozen_string_literal: true

# eeID and TARA share one OIDC client, so eeID redirects back to the callback
# URL registered for TARA. OmniAuth picks the strategy by request path, so a
# login started at /auth/eeid would otherwise be completed by the TARA strategy.
#
# The request phase of every OmniAuth strategy records its provider name in the
# session (see `remember_provider`); on the shared callback path this middleware
# rewrites PATH_INFO to the callback path of the provider that started the login.
# Logins started by TARA pass through unchanged.
class IdentityProviderCallbackRouter
  SESSION_KEY = 'omniauth.identity_provider'.freeze

  # Hook for OmniAuth.config.before_request_phase.
  def self.remember_provider(env)
    env['rack.session'][SESSION_KEY] = env['omniauth.strategy'].name.to_s
  end

  def initialize(app, shared_callback_path:, provider:, callback_path:)
    @app = app
    @shared_callback_path = shared_callback_path
    @provider = provider
    @callback_path = callback_path
  end

  def call(env)
    if env['PATH_INFO'] == @shared_callback_path
      started_by = env['rack.session']&.delete(SESSION_KEY)
      env['PATH_INFO'] = @callback_path if started_by == @provider
    end

    @app.call(env)
  end
end
