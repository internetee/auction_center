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
      broadcast_later 'auctions',
                      'auctions/streams/updated_list',
                      locals: { auction: auction }
    end
  end
end
