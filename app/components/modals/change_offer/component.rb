module Modals
  module ChangeOffer
    class Component < ApplicationViewComponent
      attr_reader :offer, :auction, :autobider, :update, :current_user, :captcha_required

      def initialize(offer:, auction:, autobider:, update:, current_user:, captcha_required:)
        super

        @offer = offer
        @auction = auction
        @autobider = autobider
        @update = update
        @current_user = current_user
        @captcha_required = captcha_required
      end

      def url
        if update
          english_offer_path(offer.uuid)
        else
          auction_english_offers_path(auction_uuid: auction.uuid)
        end
      end

      def autobider_url
        if autobider.new_record?
          autobider_index_path
        else
          autobider_path(uuid: @autobider.uuid)
        end
      end

      def offer_disabled?
        offer.auction.finished? ? true : false
      end

      def current_price(offer, current_user)
        return unless offer

        is_user_offer = offer&.billing_profile&.user_id == current_user&.id
        username = is_user_offer ? I18n.t('auctions.you').to_s : offer.username
        content_tag(:span, class: 'current_price',
                           data: { 'user-id': offer.user_id, you: I18n.t('auctions.you') }) do
          content = "#{offer.price} "
          content << content_tag(:span, (username.nil? ? '' : "(#{username})"), class: 'bidder')
          content.html_safe
        end
      end
    end
  end
end
