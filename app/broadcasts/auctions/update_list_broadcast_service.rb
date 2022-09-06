# frozen_string_literal: true

module Auctions
  class UpdateListBroadcastService < ApplicationService
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
      broadcast_later "auctions",
                      'auctions/streams/updated_list',
                      locals: { auction: auction }
    end
  end
end

# auction.broadcast_replace_to "auctions_offer_#{auction.id}",
# target: "offer_#{auction.id}_form",
# partial: 'english_offers/number_form_field',
# locals: {
#   offer_value: auction.min_bids_step,
#   offer_disabled: auction.finished? ? true : false
# }