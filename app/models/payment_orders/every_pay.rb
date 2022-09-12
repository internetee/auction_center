module PaymentOrders
  class EveryPay < PaymentOrder
    include Concerns::HttpRequester
    CONFIG_NAMESPACE = 'every_pay'.freeze

    USER = AuctionCenter::Application.config
                                     .customization
                                     .dig(:payment_methods, CONFIG_NAMESPACE.to_sym, :user)

    ACCOUNT_ID = AuctionCenter::Application.config
                                           .customization
                                           .dig(:payment_methods,
                                                CONFIG_NAMESPACE.to_sym, :account_id)
    URL = AuctionCenter::Application.config
                                    .customization
                                    .dig(:payment_methods, CONFIG_NAMESPACE.to_sym, :url)


    SUCCESSFUL_PAYMENT = %w[settled authorized].freeze

    LANGUAGE_CODE_ET = 'et'.freeze
    LANGUAGE_CODE_EN = 'en'.freeze

    def self.config_namespace_name
      CONFIG_NAMESPACE
    end

    # Where to send the POST request with payment creation.
    def form_url
      URL
    end

    # Perform necessary checks and mark the invoice as paid
    def mark_invoice_as_paid
      return unless settled_payment?

      response.with_indifferent_access
      paid!
      time = response['transaction_time'].to_datetime

      Invoice.transaction do
        invoices.each do |invoice|
          process_payment(invoice, time)
        end
      end
    end

    def process_payment(invoice, time)
      invoice.mark_as_paid_at_with_payment_order(time, self)
    end

    # Check if the intermediary reports payment as settled and we can expect money on
    # our accounts
    def settled_payment?
      SUCCESSFUL_PAYMENT.include?(response['payment_state'])
    end

    private


    def language
      if user&.locale == LANGUAGE_CODE_ET
        LANGUAGE_CODE_ET
      else
        LANGUAGE_CODE_EN
      end
    end

    def valid_amount?
      invoices_total.to_d == BigDecimal(response['amount'])
    end

    def invoices_total
      invoices.map(&:total).reduce(:+)
    end

    def base_params
      {
        api_username: USER,
        account_id: ACCOUNT_ID,
        timestamp: Time.now.to_i.to_s,
        callback_url: callback_url,
        customer_url: return_url,
        amount: invoices_total&.format(symbol: nil, thousands_separator: false, decimal_mark: '.'),
        order_reference: SecureRandom.hex(15),
        transaction_type: 'charge',
        locale: language,
        hmac_fields: '',
      }.with_indifferent_access
    end
  end
end
