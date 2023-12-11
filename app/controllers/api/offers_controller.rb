module Api
  class OffersController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    skip_before_action :verify_authenticity_token

    def create
      # Offer offer = Offer(
      #   auctionId: widget.auction.uuid,
      #   cents: _bidAmount!.toInt(),
      #   userId: user.uuid,
      # );

      # offerBloc.add(AddOfferEvent(offer: offer, authToken: user.tempTokenStore!, auctionType: widget.auction.type!));
      # Navigator.of(context).pop();
      puts '====='
      puts params
      puts '====='

      auction = Auction.find_by(uuid: params[:auctionId])

      offer = Offer.new
      offer.price = params[:cents]

      puts '====='
      puts auction.inspect
      puts offer.inspect
      puts current_user.inspect
      puts '====='

      render json: { status: 'ok' }, status: :ok
    end
  end
end
