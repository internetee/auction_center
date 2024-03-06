module Modals
  module Deposit
    class Component < ApplicationViewComponent
      attr_reader :auction, :current_user, :captcha_required

      def initialize(auction:, current_user:, captcha_required:, show_checkbox_recaptcha:)
        super

        @auction = auction
        @current_user = current_user
        @captcha_required = captcha_required
        @show_checkbox_recaptcha = show_checkbox_recaptcha
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
