module Api
  module V1
    class AutobidersController < BaseController
      respond_to :json

      skip_before_action :verify_authenticity_token

      def create
        @autobider = Autobider.find_by(user_id: current_user.id, id: strong_params[:id])

        if @autobider.nil?
          @autobider = Autobider.new(strong_params.merge(user: current_user))
        else
          @autobider.price = strong_params[:price]
        end

        if @autobider.save
          auction = Auction.where(domain_name: @autobider.domain_name).order(:created_at).last
          AutobiderService.autobid(auction) unless skip_autobid(auction)

          Auctions::UpdateListBroadcastService.call({ auction: })

          render json: { status: 'ok' }, status: :ok
        else
          render json: { status: 'error' }, status: :unprocessable_entity
        end
      end

      private

      def skip_autobid(auction)
        return false if auction.offers.empty?

        offer = auction.offers.order(:updated_at).last
        offer.user == @autobider.user
      end

      def strong_params
        params.require(:autobider).permit(:id, :domain_name, :price)
      end
    end
  end
end
