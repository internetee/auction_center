# frozen_string_literal: true

module Invoice::Linkpayable
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

  # Payment link must not outlive the invoice: the link expiry sent to EveryPay
  # is the end of the due date in Estonian time (EET/EEST) in "DD/MM/YYYY HH:MM".
  # Whether EveryPay honours "expires_at" is an unverified contract assumption.
  EXPIRY_FIELD = 'expires_at'
  EXPIRY_TIME_ZONE = 'Tallinn'
  EXPIRY_FORMAT = '%d/%m/%Y %H:%M'

  def linkpay_url
    # return unless PaymentOrder.supported_methods.include?('PaymentOrders::EveryPay'.constantize)
    return if paid?

    linkpay_url_builder
  end

  def linkpay_url_builder
    price = total&.format(symbol: nil, thousands_separator: false, decimal_mark: '.')
    data = linkpay_params(price).to_query.gsub('+', '%20')

    hmac = OpenSSL::HMAC.hexdigest('sha256', KEY, data)
    "#{LINKPAY_PREFIX}?#{data}&hmac=#{hmac}"
  end

  def linkpay_params(price)
    params = { 'transaction_amount' => price.to_s,
               'order_reference' => number,
               'customer_name' => billing_profile.name.parameterize(separator: '_', preserve_case: true),
               'customer_email' => user.email,
               'custom_field_1' => result.auction.domain_name,
               'linkpay_token' => LINKPAY_TOKEN }

    params[EXPIRY_FIELD] = linkpay_expires_at if due_date.present?

    params
  end

  def linkpay_expires_at
    due_date.in_time_zone(EXPIRY_TIME_ZONE).end_of_day.strftime(EXPIRY_FORMAT)
  end
end
