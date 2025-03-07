module Api
  module V1
    class AuctionsController < BaseController
      respond_to :json

      skip_before_action :verify_authenticity_token

      def show
        @auction = Auction.find_by!(uuid: params[:auction_id])
        offer = @auction.offer_from_user(current_user.id)
        autobider = current_user.autobiders.find_or_initialize_by(domain_name: @auction.domain_name)
        billing_profiles = BillingProfile.accessible_by(current_ability).where(user_id: current_user.id)

        render json: {
          offer:,
          autobider:,
          billing_profiles:
        }, status: :ok
      end
    end
  end
end
