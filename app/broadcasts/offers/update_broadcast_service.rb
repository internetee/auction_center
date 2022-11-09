# frozen_string_literal: true

module Offers
  class UpdateBroadcastService < ApplicationService
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
                      'english_offers/streams/updated',
                      locals: { auction: auction }
    end
  end
end
