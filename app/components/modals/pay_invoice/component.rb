module Modals
  module PayInvoice
    class Component < ApplicationViewComponent
      attr_reader :invoice

      def initialize(invoice:)
        super

        @invoice = invoice
      end

      def current_billing_profile
        params[:billing_profile_id].presence || invoice.billing_profile_id
      end

      def invoice_issuer
        Setting.find_by(code: 'invoice_issuer').retrieve 
      end

      def issuer_for
        @invoice.address
      end

      def invoice_issuer_address
        Setting.find_by(code: 'invoice_issuer_address').retrieve
      end

      def invoice_issuer_reg_no
        Setting.find_by(code: 'invoice_issuer_reg_no').retrieve
      end

      def invoice_issuer_vat_number
        Setting.find_by(code: 'invoice_issuer_vat_number').retrieve
      end

      def billing_profile_dropdown_properties
        {
          attribute: :billing_profile_id,
          enum: billing_profiles = BillingProfile.where(user_id: invoice.user_id).collect do |b|
            [b.name, b.id, { 'data-vat-rate' => b.vat_rate }]
          end,
          first_options: {},
          second_options: {
            class: billing_profiles.size == 1 ? 'disabled' : '',
            data: { action: 'change->invoice-autotax-counterr#updateTax', invoice_autotax_counter_target: 'dropdown'}
          }
        }
      end
    end
  end
end