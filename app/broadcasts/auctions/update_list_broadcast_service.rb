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
      participants = auction.offers.map(&:user)

      User.all.each do |user|
        broadcast_later "auctions_#{user.id}",
                        'auctions/streams/updated_list',
                        locals: { auction:, user:, updated: participants.include?(user) }
      end

      ActionCable.server.broadcast('auctions_api', { auction: })

      broadcast_later 'auctions',
                      'auctions/streams/updated_list',
                      locals: { auction:, user: nil, updated: false }
    end
  end
end
