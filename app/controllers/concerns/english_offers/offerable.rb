module EnglishOffers
  module Offerable
    extend ActiveSupport::Concern

    included do
      before_render :find_or_initialize_autobidder, only: %i[new create edit update]
      before_action :prevent_check_for_invalid_bid, only: [:update]
    end

    protected

    def broadcast_update_auction_offer(auction) = Offers::UpdateBroadcastService.call({ auction: })

    def update_auction_values(auction, message_text)
      AutobiderService.autobid(auction)
      auction.update_ends_at(@offer)

      flash[:notice] = message_text
      redirect_to root_path
    end

    def inform_about_invalid_bid_amount
      flash[:alert] = t('english_offers.create.bid_must_be', minimum: formatted_starting_price)

      if turbo_frame_request?
        render turbo_stream: turbo_stream.action(:redirect, root_path)
      else
        redirect_to root_path, status: :see_other
      end
    end

    def find_or_initialize_autobidder
      auction = Auction.find_by(uuid: params[:auction_uuid])
      auction = @offer.auction if auction.nil?

      @autobider = current_user&.autobiders&.find_or_initialize_by(domain_name: auction.domain_name)
    end

    # rubocop:disable Metrics/AbcSize
    def prevent_check_for_invalid_bid
      auction_uuid = params[:auction_uuid].presence || @offer.auction.uuid

      auction = Auction.with_user_offers(current_user.id).find_by(uuid: auction_uuid)
      return unless bid_is_bad?(auction:, update_params:)

      flash[:alert] = I18n.t('english_offers.show.bid_failed', price: auction_highest_prrice_message(auction))

      if turbo_frame_request?
        render turbo_stream: turbo_stream.action(:redirect, root_path)
      else
        redirect_to root_path, status: :see_other
      end
    end

    def check_first_bid_for_english_auction(params, auction)
      return true if auction.blind?

      starting_price = auction.starting_price
      price = params[:price].to_f

      price.to_f >= starting_price.to_f
    end

    private

    def auction_highest_prrice_message(auction) = format('%.2f', auction.highest_price.to_f).tr('.', ',')

    def formatted_starting_price = format('%.2f', @auction.starting_price)

    def bid_is_bad?(auction:, update_params:)
      !additional_check_for_bids(auction, update_params[:price]) ||
        !check_bids_for_english_auction(update_params, auction)
    end

    def additional_check_for_bids(auction, current_bid)
      order = auction.offers.order(updated_at: :desc).first

      Money.new(order.cents).to_f < current_bid.to_f
    end

    def check_bids_for_english_auction(params, auction)
      return true if auction.blind?

      minimum = auction.min_bids_step.to_f
      price = params[:price].to_f

      price >= minimum
    end
  end
end
