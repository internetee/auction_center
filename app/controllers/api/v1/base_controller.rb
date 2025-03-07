module Api
  module V1
    class BaseController < ApplicationController
      before_action :check_for_authentication

      def check_for_authentication
        render json: { errors: 'Unauthorized' }, status: 401 if current_user.nil?
      end
    end
  end
end
