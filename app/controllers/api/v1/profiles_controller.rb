module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user!, only: %i[update]
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

      def create
        puts '----'
        puts params_for_create
        puts '----'

        user = User.new(params_for_create)

        if user.save
          sign_in(User, user)
          render json: user, status: :created
        else
          Rails.logger.info user.errors.inspect
          render json: user.errors, status: :unprocessable_entity
        end
      end

      private

      def params_for_create
        params.require(:user).permit(:email, :password, :password_confirmation, :country_code,
                                     :given_names, :surname, :mobile_phone, :accepts_terms_and_conditions,
                                     :locale, :daily_summary, :identity_code)
      end

      def params_for_update
        params.require(:user).permit(:email, :country_code, :given_names, :surname, :mobile_phone)
      end
    end
  end
end
