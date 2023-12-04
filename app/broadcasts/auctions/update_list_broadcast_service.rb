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
      ActionCable.server.broadcast('auctions_api', { auction: })

      broadcast_later 'auctions',
                      'auctions/streams/updated_list',
                      locals: { auction: }
    end
  end
end
