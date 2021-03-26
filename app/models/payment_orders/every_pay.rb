module PaymentOrders
  class EveryPay < PaymentOrder
    CONFIG_NAMESPACE = 'every_pay'.freeze

    USER = AuctionCenter::Application.config
                                     .customization
                                     .dig(:payment_methods, CONFIG_NAMESPACE.to_sym, :user)
    KEY = AuctionCenter::Application.config
                                    .customization
                                    .dig(:payment_methods, CONFIG_NAMESPACE.to_sym, :key)
    ACCOUNT_ID = AuctionCenter::Application.config
                                           .customization
                                           .dig(:payment_methods,
                                                CONFIG_NAMESPACE.to_sym, :account_id)
    URL = AuctionCenter::Application.config
                                    .customization
                                    .dig(:payment_methods, CONFIG_NAMESPACE.to_sym, :url)
    ICON = AuctionCenter::Application.config
                                     .customization
                                     .dig(:payment_methods, CONFIG_NAMESPACE.to_sym, :icon)
    LINKPAY_PREFIX = AuctionCenter::Application.config
                                               .customization
                                               .dig(:payment_methods,
                                                    CONFIG_NAMESPACE.to_sym, :linkpay_prefix)

    LINKPAY_TOKEN = AuctionCenter::Application.config
                                              .customization
                                              .dig(:payment_methods,
                                                   CONFIG_NAMESPACE.to_sym, :linkpay_token)

    SUCCESSFUL_PAYMENT = %w[settled authorized].freeze

    LANGUAGE_CODE_ET = 'et'.freeze
    LANGUAGE_CODE_EN = 'en'.freeze

    # Base interface for creating payments.
    def form_fields
      base_json = base_params
      base_json[:nonce] = SecureRandom.hex(15)
      hmac_fields = (base_json.keys + ['hmac_fields']).sort.uniq!

      base_json[:hmac_fields] = hmac_fields.join(',')
      hmac_string = hmac_fields.map { |key, _v| "#{key}=#{base_json[key]}" }.join('&')
      hmac = OpenSSL::HMAC.hexdigest('sha1', KEY, hmac_string)
      base_json[:hmac] = hmac

      base_json
    end

    def self.config_namespace_name
      CONFIG_NAMESPACE
    end

    def self.icon
      with_cache do
        AuctionCenter::Application.config
                                  .customization
                                  .dig(:payment_methods, config_namespace_name.to_sym, :icon)
      end
    end

    # Where to send the POST request with payment creation.
    def form_url
      URL
    end

    # Perform necessary checks and mark the invoice as paid
    def mark_invoice_as_paid
      return unless settled_payment? && valid_response?

      paid!
      time = Time.strptime(response['timestamp'], '%s')
      Invoice.transaction do
        invoices.each do |invoice|
          invoice.mark_as_paid_at_with_payment_order(time, self)
        end
      end
    end

    # Check if response is there and if basic security methods are fullfilled.
    def valid_response?
      return false unless response

      valid_hmac? && valid_amount? && valid_account?
    end

    # Check if the intermediary reports payment as settled and we can expect money on
    # our accounts
    def settled_payment?
      SUCCESSFUL_PAYMENT.include?(response['payment_state'])
    end

    def url_builder
      total = invoices_total&.format(symbol: nil, thousands_separator: false, decimal_mark: '.')
      params = {'transaction_amount' => "#{total}",
                'order_reference' => uuid,
                'linkpay_token' => LINKPAY_TOKEN}

      data = params.to_query

      hmac = OpenSSL::HMAC.hexdigest('sha256', KEY, data)
      "#{LINKPAY_PREFIX}?#{data}&hmac=#{hmac}"
    end

    private

    def language
      if user&.locale == LANGUAGE_CODE_ET
        LANGUAGE_CODE_ET
      else
        LANGUAGE_CODE_EN
      end
    end

    def valid_hmac?
      hmac_fields = response['hmac_fields'].split(',')
      hmac_hash = {}
      hmac_fields.map do |field|
        hmac_hash[field] = response[field]
      end

      hmac_string = hmac_hash.map { |key, _v| "#{key}=#{hmac_hash[key]}" }.join('&')
      expected_hmac = OpenSSL::HMAC.hexdigest('sha1', KEY, hmac_string)
      expected_hmac == response['hmac']
    end

    def valid_amount?
      invoices_total.to_d == BigDecimal(response['amount'])
    end

    def invoices_total
      invoices.map(&:total).reduce(:+)
    end

    def valid_account?
      response['account_id'] == ACCOUNT_ID
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
