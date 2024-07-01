module Modals
  module ChangeOffer
    class Component < ApplicationViewComponent
      attr_reader :offer, :auction, :autobider, :update, :current_user, :captcha_required, :show_checkbox_recaptcha

      def initialize(offer:, auction:, autobider:, update:, current_user:, captcha_required:, show_checkbox_recaptcha:)
        super

        @offer = offer
        @auction = auction
        @autobider = autobider
        @update = update
        @current_user = current_user
        @captcha_required = captcha_required
        @show_checkbox_recaptcha = show_checkbox_recaptcha
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

      # def current_price(offer, current_user)
      #   return unless offer

      #   is_user_offer = offer&.billing_profile&.user_id == current_user&.id
      #   username = is_user_offer ? I18n.t('auctions.you').to_s : offer.username
      #   content_tag(:span, class: 'current_price',
      #                      data: { 'user-id': offer.user_id, you: I18n.t('auctions.you') }) do
      #     content = "#{offer.price} "
      #     content << content_tag(:span, (username.nil? ? '' : "(#{username})"), class: 'bidder')
      #     content.html_safe
      #   end
      # end

      def current_price
        return Money.new(0) unless last_actual_offer

        last_actual_offer.price
      end

      def current_bidder
        return unless last_actual_offer

        is_user_offer = last_actual_offer&.billing_profile&.user_id == current_user&.id
        username = is_user_offer ? I18n.t('auctions.you').to_s : last_actual_offer.username

        username
      end

      def last_actual_offer
        @last_actual_offer ||= auction.offers.order(updated_at: :desc).first
      end

      def number_field_properties
        {
          attribute: :price,
          options: {
            min: 0.0,
            step: 0.01,
            # value: number_with_precision(@autobider.price.to_f, precision: 2) || @auction.min_bids_step.to_f,
            value: number_with_precision(@autobider.price.to_f, precision: 2, delimiter: '', separator: '.') || @auction.min_bids_step.to_f,
            disabled: is_number_field_disabled?,
            data: {
              action: 'keydown->form--autobider-submit#validatePrice input->form--autobider-submit#validatingInputPrice',
              form__autobider_submit_target: 'price',
              form__autobider_validation_target: 'bidInput'
            }
          }
        }
      end

      def autobider_form_properties
        {
          model: @autobider,
          url: autobider_url,
          data: {
            turbo_frame: '_top',
            controller: 'form--autobider-submit form--autobider-validation',
            form__autobider_submit_target: 'form',
            form__autobider_validation_bid_min_value: @auction.min_bids_step.to_f
          },
          html: { id: ' autobid_form ' }
        }
      end

      def autobider_checkbox_properties
        {
          attribute: :enable,
          options: {
            id: 'checkbox',
            data: {
              form__autobider_submit_target: 'checkbox',
              action: 'change->form--autobider-submit#submitAutobider'
            }
          }
        }
      end

      def is_number_field_disabled?
        @auction.finished? ? true : false
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
            autotax_counter_defaulttemplate_value: t('offers.price_is_without_vat'),
            autotax_counter_separator_value: I18n.locale == :en ? '.' : ',',
          }
        }
      end

      def billing_profile_dropdown_properties
        {
          attribute: :billing_profile_id, 
          enum: billing_profiles = BillingProfile.where(user_id: offer.user_id).collect do |b| 
            [b.name, b.id, {'data-vat-rate' => b.vat_rate}] 
          end,
          first_options: { },
          second_options: { 
            class: billing_profiles.size == 1 ? "disabled" : "",
            data: { action: 'change->autotax-counter#updateTax' } 
          }
        }
      end
    end
  end
end
