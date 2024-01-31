module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user!
      respond_to :json

      skip_before_action :verify_authenticity_token

      def update
        if current_user.update(params_for_update)
          render json: current_user, status: :ok
        else
          Rails.logger.info @user.errors.inspect
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

      def params_for_update
        params.require(:user).permit(:email, :country_code, :given_names, :surname, :mobile_phone)
      end
    end
  end
end
