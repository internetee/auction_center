module Api
  module V1
    class AutobidersController < ApplicationController
      before_action :authenticate_user!
      respond_to :json

      skip_before_action :verify_authenticity_token

      def create
        autobider = Autobider.find_by(user_id: current_user.id, domain_name: strong_params[:domain_name])

        print('---- autobider ---- ')
        print(params)
        print('---- autobider ---- ')

        if autobider.nil?
          autobider = Autobider.new(strong_params.merge(user: current_user))
        else
          autobider.price = strong_params[:price]
        end

        if autobider.save
          render json: { status: 'ok' }, status: :ok
        else
          render json: { status: 'error' }, status: :unprocessable_entity
        end
      end

      def strong_params
        params.require(:autobider).permit(:domain_name, :price)
      end
    end
  end
end
