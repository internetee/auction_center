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

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def post_call
      participants = auction.offers.map(&:user)

      User.all.each do |user|
        broadcast_later "auctions_#{user.id}",
                        'auctions/streams/updated_list',
                        locals: { auction:, user:, updated: participants.include?(user) }
      end


      auction_json = {
        domain_name: auction.domain_name,
        starts_at: auction.starts_at,
        ends_at: auction.ends_at,
        id: auction.uuid,
        highest_bid: auction.currently_winning_offer&.price.to_f,
        highest_bidder: auction.currently_winning_offer&.username,
        min_bids_step: auction.min_bids_step,
        auction_type: auction&.platform,
        enable_deposit: auction.enable_deposit,
        requirement_deposit_in_cents: auction.requirement_deposit_in_cents
      }

      ActionCable.server.broadcast('auctions_api', { auction: auction_json })

      broadcast_later 'auctions',
                      'auctions/streams/updated_list',
                      locals: { auction:, user: nil, updated: false }
    end
  end
end
