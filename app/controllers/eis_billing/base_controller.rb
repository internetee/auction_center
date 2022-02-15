module EisBilling
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
    skip_authorization_check # Temporary solution
    # skip_before_action :verify_authenticity_token # Temporary solution
    before_action :persistent
    before_action :authorized

    SECRET_WORD = AuctionCenter::Application.config
                                            .customization[:billing_system_integration]
                                            &.compact&.fetch(:secret_word, '')

    SECRET_ACCESS_WORD = AuctionCenter::Application.config
                                                   .customization[:billing_system_integration]
                                                   &.compact&.fetch(:secret_access_word, '')

    def encode_token(payload)
      JWT.encode(payload, SECRET_WORD)
    end

    def auth_header
      # { Authorization: 'Bearer <token>' }
      request.headers['Authorization']
    end

    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, SECRET_WORD, true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end
    end

    def accessable_service
      if decoded_token
        decoded_token[0]['data'] == SECRET_ACCESS_WORD
      end
    end

    def logged_in?
      !!accessable_service
    end

    def authorized
      render json: { message: 'Access denied' }, status: :unauthorized unless logged_in?
    end

    def logger
      Rails.logger
    end

    def logger
      @logger ||= Rails.logger
    end

    def persistent
      return true if Feature.billing_system_integration_enabled?

      render json: { message: "We don't work yet!" }, status: :unauthorized
    end
  end
end
