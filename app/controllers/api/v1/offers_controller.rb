module Api
  module V1
    class OffersController < ApplicationController
      before_action :authenticate_user!
      respond_to :json

      skip_before_action :verify_authenticity_token

      def index
        offers = Offer.includes(:auction)
                      .includes(:result)
                      .where(user_id: current_user)
                      .order('auctions.ends_at DESC')

        # price with tax
        render json: offers.as_json(
          include: %i[auction billing_profile],
          methods: %i[auction_status api_price api_total api_bidders]
        )
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def create
        auction = Auction.find_by(uuid: params[:bid][:auction_id])
        return if auction.nil?

        billing_profile = current_user.billing_profiles.find_by(id: params[:bid][:billing_profile_id])

        offer = auction.offer_from_user(current_user.id)

        if offer.nil?
          offer = Offer.new(
            auction:,
            user: current_user,
            cents: Money.from_amount(params[:bid][:price]).cents,
            billing_profile:,
            username: auction.english? ? Username::GenerateUsernameService.new.call : nil
          )
        else
          offer.cents = Money.from_amount(params[:bid][:price]).cents
        end

        if offer.save
          if auction.english?
            Auctions::UpdateListBroadcastService.call({ auction: })

            auction.update_minimum_bid_step(params[:bid][:price].to_f)

            AutobiderService.autobid(auction)
            auction.update_ends_at(offer)
          end

          render json: { status: 'ok' }, status: :ok
        else

          Rails.logger.info('----')
          Rails.logger.info(offer.errors.inspect)
          Rails.logger.info('----')

          render json: { status: 'error' }, status: :unprocessable_entity
        end
      end
    end
  end
end
