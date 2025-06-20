module Api
  module V1
    class BaseController < ApplicationController
      before_action :api_turn_off
      before_action :check_for_authentication
      respond_to :json

      def check_for_authentication
        if token = extract_token_from_header
          begin
            decoded_token = decode_token(token)
            payload = decoded_token[0]

            if user_id = payload['sub']
              @current_user = User.find_by(id: user_id)
              sign_in(@current_user) if @current_user
            end
          rescue JWT::DecodeError => e
            Rails.logger.error "JWT decode error: #{e.message}"
          rescue StandardError => e
            Rails.logger.error "Authentication error: #{e.message}"
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
    end
  end
end
