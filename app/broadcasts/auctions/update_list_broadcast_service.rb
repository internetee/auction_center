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
      puts '------- DO YOU WORK?'
      ActionCable.server.broadcast('auctions_api', { auction: })
      puts '----------'


      broadcast_later 'auctions',
                      'auctions/streams/updated_list',
                      locals: { auction: }
    end
  end
end
