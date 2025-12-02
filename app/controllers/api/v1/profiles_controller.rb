module Api
  module V1
    class ProfilesController < BaseController
      respond_to :json

      skip_before_action :verify_authenticity_token
      skip_before_action :check_for_authentication, only: %i[create]

      def update
        if current_user.update(params_for_update)
          render json: current_user, status: :ok
        else
          Rails.logger.info current_user.errors.inspect
          render json: { errors: user.errors.to_hash(true) }, status: :unprocessable_entity
        end
      end

      def create
        user = initialize_user(params_for_create)
        set_locale_for user

        if user.save
          # sign_in(User, user)
          render json: user, status: :created
        else
          Rails.logger.info user.errors.inspect
          render json: { errors: user.errors.to_hash(true) }, status: :unprocessable_entity
        end
      end

      private

      def initialize_user(params_for_create)
        User.new(params_for_create)
      end

      def params_for_create
        params.require(:user).permit(:email, :password, :password_confirmation, :country_code, :alpha_two_country_code,
                                     :given_names, :surname, :mobile_phone, :accepts_terms_and_conditions,
                                     :locale, :daily_summary, :identity_code)
      end
      
      def set_locale_for(user)
        I18n.locale = user.locale || I18n.default_locale
      end

      def params_for_update
        params.require(:user).permit(:email, :country_code, :given_names, :surname, :mobile_phone)
      end
    end
  end
end
