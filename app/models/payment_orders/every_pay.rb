module PaymentOrders
  class EveryPay < PaymentOrder
    USER = AuctionCenter::Application.config
                                     .customization
                                     .dig('payment_methods', 'every_pay', 'user')
    KEY = AuctionCenter::Application.config
                                    .customization
                                    .dig('payment_methods', 'every_pay', 'key')
    ACCOUNT_ID = AuctionCenter::Application.config
                                           .customization
                                           .dig('payment_methods', 'every_pay', 'account_id')
    URL = AuctionCenter::Application.config
                                    .customization
                                    .dig('payment_methods', 'every_pay', 'url')
    ICON = AuctionCenter::Application.config
                                     .customization
                                     .dig('payment_methods', 'every_pay', 'icon')

    SUCCESSFUL_PAYMENT = %w[settled authorized].freeze

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

    def self.icon
      ICON
    end

    # Where to send the POST request with payment creation.
    def form_url
      URL
    end

    # Perform necessary checks and mark the invoice as paid
    def mark_invoice_as_paid
      return unless valid_response? && settled_payment?

      time = Time.strptime(response['timestamp'], '%s')
      invoice.mark_as_paid_at(time)
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

    private

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
      invoice.total.to_d == BigDecimal(response['amount'])
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
        amount: invoice.total.to_s,
        order_reference: SecureRandom.hex(15),
        transaction_type: 'charge',
        hmac_fields: '',
      }.with_indifferent_access
    end
  end
end
