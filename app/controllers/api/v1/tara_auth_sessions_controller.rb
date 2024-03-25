module Api
  module V1
    class TaraAuthSessionsController < ApplicationController
      before_action :check_for_permission, only: %i[create]

      respond_to :json

      skip_before_action :verify_authenticity_token

      def create
        identity = params[:identity_code]
        first_name = params[:first_name]
        last_name = params[:last_name]
        country_code = params[:country_code]

        @user = User.find_by(identity_code: identity, country_code: country_code)
        @user.update(given_names: first_name, surname: last_name) if @user.present?

        if @user.present?
          sign_in(User, @user)
          render json: { message: 'User signed in', user: @user, token: current_token }, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      private

      def check_for_permission
        # TODO:
        true
      end

      def current_token
        request.env['warden-jwt_auth.token']
      end
    end
  end
end
