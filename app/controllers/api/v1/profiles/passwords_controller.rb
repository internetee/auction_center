module Api
  module V1
    module Profiles
      class PasswordsController < ApplicationController
        before_action :authenticate_user!
        respond_to :json

        skip_before_action :verify_authenticity_token

        def update
          puts params_for_update

          if current_user.valid_password?(params[:user][:current_password])
            if current_user.update(params_for_update)
              bypass_sign_in(current_user)
              render json: current_user, status: :ok
            else
              Rails.logger.info current_user.errors.inspect
              render json: current_user.errors, status: :unprocessable_entity
            end
          else
            render json: { errors: [t('.incorrect_password')] }, status: :unprocessable_entity
          end
        end

        def params_for_update
          params.require(:user).permit(:password, :password_confirmation)
        end
      end
    end
  end
end
