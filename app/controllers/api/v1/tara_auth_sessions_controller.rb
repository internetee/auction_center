module Api
  module V1
    class TaraAuthSessionsController < ApplicationController
      respond_to :json

      skip_before_action :verify_authenticity_token

      def create
        received_hmac = params[:token]
        message = Rails.configuration.customization[:mobile_secret_word]

        unless valid_hmac?(received_hmac, message)
          render json: { error: 'Invalid HMAC' }, status: :unauthorized
          return
        end

        identity = params[:identity_code]
        first_name = params[:first_name]
        last_name = params[:last_name]
        country_code = params[:country_code]

        @user = User.find_by(identity_code: identity, country_code:)
        @user.update(given_names: first_name, surname: last_name) if @user.present?

        if @user.present?
          sign_in(User, @user)
          render json: { message: 'User signed in', user: @user, token: current_token }, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      private

      def valid_hmac?(received_hmac, message)
        secret_key = Rails.configuration.customization[:mobile_secret_key]
        digest = OpenSSL::Digest.new('sha256')
        hmac = OpenSSL::HMAC.digest(digest, secret_key, message)
        Base64.strict_encode64(hmac) == received_hmac
      end

      def current_token
        request.env['warden-jwt_auth.token']
      end
    end
  end
end
