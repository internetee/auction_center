module Modals
  module ChangeOfferPo
    class Component < ApplicationViewComponent
      attr_reader :offer, :auction, :update, :current_user, :captcha_required

      def initialize(offer:, auction:, update:, current_user:, captcha_required:)
        super

        @offer = offer
        @auction = auction
        @update = update
        @current_user = current_user
        @captcha_required = captcha_required
      end

      def url
        if update
          offer_path(@offer.uuid)
        else
          auction_offers_path(auction_uuid: params[:auction_uuid])
        end
      end

      def offer_disabled?
        offer.auction.finished? ? true : false
      end

      def current_price
        auction.offer_from_user(current_user).present? ? auction.current_price_from_user(current_user) : Money.new(Setting.find_by(code: 'auction_minimum_offer').retrieve)
      end
    end
  end
end