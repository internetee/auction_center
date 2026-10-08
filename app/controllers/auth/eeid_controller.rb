# frozen_string_literal: true

module Auth
  # Sign-in and sign-up through eeID. Kept separate from Auth::TaraController so that
  # TARA stays an untouched fallback while eeID is rolled out (`eeid_login_enabled`).
  class EeidController < ApplicationController
    include InvalidUserDataHelper
    after_action :set_invalid_data_flag_in_session, only: %i[callback create]

    rescue_from Errors::TamperingDetected do |e|
      redirect_to root_url, alert: t('auth.eeid.tampering')
      notify_airbrake(e)
    end

    before_action do
      I18n.locale = cookies[:locale] || I18n.default_locale
    end

    def callback
      return redirect_to(root_path, alert: t('auth.eeid.identity_code_missing')) unless identity_code_received?

      @user = User.from_omniauth(user_hash)

      if @user.persisted?
        sign_in(User, @user)
        redirect_to stored_location_for(:user) || root_path, notice: t('devise.sessions.signed_in')
      else
        session[:omniauth_hash] = signup_identity
        render :callback
      end
    end

    def create
      @user = User.new(create_params)
      check_for_tampering
      @user.password = Devise.friendly_token[0..20]

      if @user.save
        session.delete(:omniauth_hash)
        sign_in(User, @user)
        redirect_to stored_location_for(:user) || root_path, notice: t(:created)
      else
        render :callback
      end
    end

    def cancel
      redirect_to root_path, notice: t('sign_in_cancelled')
    end

    private

    def create_params
      params.require(:user)
            .permit(:email, :identity_code, :country_code, :given_names, :surname,
                    :accepts_terms_and_conditions, :locale, :uid, :provider)
    end

    # Only the attributes that the sign-up form must not change; keeps the cookie small.
    def signup_identity
      {
        'provider' => user_hash['provider'],
        'uid' => user_hash['uid'],
        'info' => {
          'first_name' => user_hash.dig('info', 'first_name'),
          'last_name' => user_hash.dig('info', 'last_name')
        }
      }
    end

    def identity_code_received?
      return false if user_hash.blank?

      User.split_identity_uid(user_hash['uid'].to_s, user_hash['provider']).last.present?
    end

    # The sign-up form posts the identity back; it must match what eeID returned.
    def check_for_tampering
      identity = session[:omniauth_hash]
      return if identity.present? && !@user.tampered_with?(identity)

      session.delete(:omniauth_hash)
      raise Errors::TamperingDetected
    end

    def user_hash
      request.env['omniauth.auth']
    end
  end
end
