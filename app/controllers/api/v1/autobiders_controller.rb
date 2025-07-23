module Api
  module V1
    class AutobidersController < BaseController
      respond_to :json
      skip_before_action :verify_authenticity_token
      before_action :price_must_be_positive, only: :create

      def create
        @autobider = Autobider.find_by(user_id: current_user.id, id: strong_params[:id])
        initialize_or_assign_values_for_autobider

        if @autobider.save
          process_autobid
          render json: { status: 'ok' }, status: :ok
        else
          render json: { status: 'error', message: @autobider.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      rescue StandardError => e
        Rails.logger.error "Error: #{e.message}"
        render json: { status: 'error', message: e.message }, status: :unprocessable_entity
      end

      private

      def process_autobid
        auction = Auction.where(domain_name: @autobider.domain_name).order(:created_at).last
        autobid!(auction)
        call_broadcast_service(auction)
      end

      def autobid!(auction)
        return if skip_autobid(auction)

        AutobiderService.autobid(auction)
      end

      def call_broadcast_service(auction)
        Auctions::UpdateListBroadcastService.call({ auction: })
      end

      def initialize_or_assign_values_for_autobider
        if @autobider.nil?
          @autobider = Autobider.new(strong_params.except(:id).merge(user: current_user, enable: true))
        else
          @autobider.assign_initialize_params_for_mobile_api(strong_params)
        end
      end

      def skip_autobid(auction)
        return false if auction.offers.empty?

        offer = auction.offers.order(:updated_at).last
        offer.user == @autobider.user
      end

      def strong_params
        params.require(:autobider).permit(:id, :domain_name, :price)
      end

      def price_must_be_positive
        return if strong_params[:price].to_d > 0
  
        render json: { status: 'error', message: 'Price must be greater than 0' }, status: :unprocessable_entity
      end
    end
  end
end
