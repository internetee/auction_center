module Offers
  class ReplaceBroadcastService < ApplicationService
    attr_reader :offer

    def initialize(params)
      super

      @offer = params[:offer]
    end

    def call
      post_call
    end

    private

    def post_call
      broadcast_later 'auctions',
                      'english_offers/streams/replaced',
                      locals: { offer: offer }
    end
  end
end

    # broadcast_replace_to('auctions',
    #                      target: dom_id(self.auction).to_s,
    #                      partial: 'auctions/auction',
    #                      locals: { auction: Auction.with_user_offers(user.id).find_by(uuid: auction.uuid),
    #                                current_user: self.user })