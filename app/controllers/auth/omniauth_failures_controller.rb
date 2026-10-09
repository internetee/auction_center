# frozen_string_literal: true

module Auth
  # OmniAuth redirects here when TARA or eeID returns an error to the callback
  # (e.g. invalid_scope, access_denied).
  class OmniauthFailuresController < ApplicationController
    before_action do
      I18n.locale = cookies[:locale] || I18n.default_locale
    end

    def show
      Rails.logger.warn("Sign in through #{params[:strategy]} failed: #{params[:message]}")
      redirect_to root_path, alert: t('auth.omniauth_failures.sign_in_failed')
    end
  end
end
