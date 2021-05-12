# frozen_string_literal: true

module Concerns
  module Invoice
    module Linkpayable
      extend ActiveSupport::Concern
      CONFIG_NAMESPACE = 'every_pay'

      KEY = AuctionCenter::Application.config
                                      .customization
                                      .dig(:payment_methods, CONFIG_NAMESPACE.to_sym, :key)
      LINKPAY_PREFIX = AuctionCenter::Application.config
                                                 .customization
                                                 .dig(:payment_methods,
                                                      CONFIG_NAMESPACE.to_sym, :linkpay_prefix)
      LINKPAY_CHECK_PREFIX = AuctionCenter::Application.config
                                                       .customization
                                                       .dig(:payment_methods,
                                                            CONFIG_NAMESPACE.to_sym,
                                                            :linkpay_check_prefix)
      LINKPAY_TOKEN = AuctionCenter::Application.config
                                                .customization
                                                .dig(:payment_methods,
                                                     CONFIG_NAMESPACE.to_sym, :linkpay_token)

      def linkpay_url
        return unless PaymentOrder.supported_methods.include?('PaymentOrders::EveryPay'.constantize)
        return if paid?

        linkpay_url_builder
      end

      def linkpay_url_builder
        price = total&.format(symbol: nil, thousands_separator: false, decimal_mark: '.')
        data = linkpay_params(price).to_query

        hmac = OpenSSL::HMAC.hexdigest('sha256', KEY, data)
        "#{LINKPAY_PREFIX}?#{data}&hmac=#{hmac}"
      end

      def linkpay_params(price)
        { 'transaction_amount' => price.to_s,
          'order_reference' => id,
          'customer_name' => billing_profile.name
                                            .parameterize(separator: '_', preserve_case: true),
          'customer_email' => user.email,
          'custom_field_1' => result.auction.domain_name,
          'linkpay_token' => LINKPAY_TOKEN }
      end
    end
  end
end
