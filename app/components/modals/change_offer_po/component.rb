module Modals
  module ChangeOfferPo
    class Component < ApplicationViewComponent
      attr_reader :offer, :auction, :update, :current_user, :captcha_required, :show_checkbox_recaptcha

      def initialize(offer:, auction:, update:, current_user:, captcha_required:, show_checkbox_recaptcha:)
        super

        @offer = offer
        @auction = auction
        @update = update
        @current_user = current_user
        @captcha_required = captcha_required
        @show_checkbox_recaptcha = show_checkbox_recaptcha
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
        if auction.offer_from_user(current_user).present?
          auction.current_price_from_user(current_user)
        else
          Money.new(Setting.find_by(code: 'auction_minimum_offer').retrieve)
        end
      end

      def minimum_offer
        I18n.t('.offers.form.minimum_offer', minimum: Money.new(Setting.find_by(code: 'auction_minimum_offer').retrieve,
                                                    Setting.find_by(code: 'auction_currency').retrieve))
      end

      def offer_form_properties
        {
          model: @offer,
          url:,
          id: 'english_offer_form',
          data: {
            turbo: false,
            controller: 'autotax-counter',
            autotax_counter_template_value: t('english_offers.price_with_wat_template'),
            autotax_counter_tax_value: "#{offer.billing_profile.present? ? offer.billing_profile.vat_rate : 0.0}",
            autotax_counter_defaulttemplate_value: t('offers.price_is_without_vat')
          }
        }
      end

      def billing_profile_dropdown_properties
        {
          attribute: :billing_profile_id,
          enum: billing_profiles = BillingProfile.where(user_id: offer.user_id).collect do |b|
            [b.name, b.id, { 'data-vat-rate' => b.vat_rate }]
          end,
          first_options: {},
          second_options: {
            class: billing_profiles.size == 1 ? 'disabled' : '',
            data: { action: 'change->autotax-counter#updateTax' }
          }
        }
      end

      def delete_action_button_properties
        {
          type: 'delete',
          href: offer_path(@auction.offer_from_user(current_user).uuid),
          options: {
            method: :delete,
            form: {
              data: {
                turbo_confirm: t('.confirm_delete')
              }
            },
            target: '_top'
          }
        }
      end

      def submit_form_button_properties
        {
          class: "c-btn c-btn--green",
          id: 'bid_action',
          form: 'english_offer_form',
          style: 'cursor: pointer;',
          data: { 
            turbo: false 
          }
        }
      end
    end
  end
end
