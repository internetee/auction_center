module Api
  module V1
    class BaseController < ApplicationController
      before_action :api_turn_off
      before_action :check_for_authentication
      respond_to :json

      before_action :set_locale

      rescue_from StandardError, with: :handle_standard_error
      rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
      rescue_from JWT::DecodeError, with: :handle_jwt_decode_error
      rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

      def check_for_authentication
        if token = extract_token_from_header
          decoded_token = decode_token(token)
          payload = decoded_token[0]

          if user_id = payload['sub']
            @current_user = User.find_by(id: user_id)
            sign_in(@current_user) if @current_user
          end
        end

        render json: { errors: 'Unauthorized' }, status: 401 if current_user.nil?
      end

      private

      def api_turn_off
        return if Feature.mobile_api_enabled?

        render json: { errors: 'API is turned off' }, status: 403
      end

      def decode_token(token)
        JWT.decode(token, AuctionCenter::Application.config.customization[:jwt_secret], true, { algorithm: 'HS256' })
      end

      def extract_token_from_header
        header = request.headers['HTTP_AUTHORIZATION']
        return nil unless header

        header.split(' ').last if header.start_with?('Bearer ')
      end

      def set_locale
        return unless user_signed_in?

        I18n.locale = current_user.locale || I18n.default_locale
      end

      def handle_standard_error(e)
        Rails.logger.error "Error: #{e.message}"
        render json: { errors: e.message }, status: :internal_server_error
      end

      def handle_record_not_found(e)
        Rails.logger.error "Record not found: #{e.message}"
        render json: { errors: 'Record not found' }, status: :not_found
      end

      def handle_jwt_decode_error(e)
        Rails.logger.error "JWT decode error: #{e.message}"
        render json: { errors: 'Invalid token' }, status: :unauthorized
      end

      def handle_parameter_missing(e)
        Rails.logger.info "param is missing or the value is empty - autobider: #{e}"
        render json: { errors: 'param is missing or the value is empty' }, status: :bad_request
      end
    end
  end
end
