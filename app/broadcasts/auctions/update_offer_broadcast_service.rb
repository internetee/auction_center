module Auctions
  class UpdateOfferBroadcastService < ApplicationService
    attr_reader :auction

    def initialize(params)
      super

      @auction = params[:auction]
    end

    def call
      post_call
    end

    private

    def post_call
      broadcast_later "auctions_offer_#{auction.id}",
                      'auctions/streams/updated_offer',
                      locals: { auction: auction }
    end
  end
end
