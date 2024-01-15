module Api
  module V1
    class OffersController < ApplicationController
      before_action :authenticate_user!
      respond_to :json

      skip_before_action :verify_authenticity_token

      def create
        auction = Auction.find_by(uuid: params[:bid][:auction_id])
        return if auction.nil?
        
        offer = auction.offer_from_user(current_user.uuid)

        billing_profile = current_user.billing_profiles.find_by(uuid: params[:bid][:billing_profile_id])
      
        if offer.nil?
          offer = Offer.new(
            auction: auction,
            user: current_user,
            cents: Money.from_amount(params[:bid][:price]).cents,
            billing_profile: billing_profile,
            username: Username::GenerateUsernameService.new.call
          )
        else
          offer.cents = Money.from_amount(params[:bid][:price]).cents
        end

        if offer.save
          Auctions::UpdateListBroadcastService.call({ auction: auction })

          auction.update_minimum_bid_step(params[:bid][:price].to_f)

          AutobiderService.autobid(auction)
          auction.update_ends_at(offer)

          render json: { status: 'ok' }, status: :ok
        else
          render json: { status: 'error' }, status: :unprocessable_entity
        end
      end
    end
  end
end
