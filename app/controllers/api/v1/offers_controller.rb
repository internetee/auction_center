module Api
  module V1
    class OffersController < BaseController
      respond_to :json

      skip_before_action :verify_authenticity_token
      before_action :set_auction, only: [:create]

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

      def create
        @offer = initialize_or_assign_price_to_offer

        if @offer.save
          process_english_auction if @auction.english?
          render json: { status: 'ok' }, status: :ok
        else
          Rails.logger.info "Offer errors (details): #{ @offer.errors.details }"
          render json: { status: 'error', errors: @offer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_auction
        @auction = Auction.find_by(uuid: offer_params[:auction_id])
        return if @auction.present?

        render_error("Auction with #{offer_params[:auction_id]} uuid not found")
      end

      def process_english_auction
        call_broadcast
        @auction.update_minimum_bid_step(offer_params[:price].to_f)
        AutobiderService.autobid(@auction)
        @auction.update_ends_at(@offer)
      end

      def call_broadcast
        Auctions::UpdateListBroadcastService.call({ auction: @auction })
      end

      def initialize_or_assign_price_to_offer
        offer = @auction.offer_from_user(current_user.id)

        if offer.nil?
          offer = Offer.new(
            auction: @auction,
            user: current_user,
            cents: Money.from_amount(offer_params[:price]).cents,
            billing_profile:,
            username: @auction.english? ? Username::GenerateUsernameService.new.call : nil
          )
        else
          offer.cents = Money.from_amount(offer_params[:price]).cents
        end

        offer
      end

      def billing_profile
        current_user.billing_profiles.find_by(id: offer_params[:billing_profile_id])
      end

      def offer_params
        params.require(:bid).permit(:auction_id, :price, :billing_profile_id)
      end
    end
  end
end
