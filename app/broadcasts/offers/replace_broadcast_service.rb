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
