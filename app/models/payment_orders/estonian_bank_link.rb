module PaymentOrders
  class EstonianBankLink < PaymentOrder
    BANK_LINK_VERSION = '008'.freeze

    NEW_TRANSACTION_SERVICE_NUMBER    = '1012'.freeze
    SUCCESSFUL_PAYMENT_SERVICE_NUMBER = '1111'.freeze
    CANCELLED_PAYMENT_SERVICE_NUMBER  = '1911'.freeze

    LANGUAGE_CODE_ET = 'EST'.freeze
    LANGUAGE_CODE_EN = 'ENG'.freeze

    NEW_MESSAGE_KEYS     = %w[VK_SERVICE VK_VERSION VK_SND_ID VK_STAMP VK_AMOUNT
                              VK_CURR VK_REF VK_MSG VK_RETURN VK_CANCEL
                              VK_DATETIME].freeze
    SUCCESS_MESSAGE_KEYS = %w[VK_SERVICE VK_VERSION VK_SND_ID VK_REC_ID VK_STAMP
                              VK_T_NO VK_AMOUNT VK_CURR VK_REC_ACC VK_REC_NAME
                              VK_SND_ACC VK_SND_NAME VK_REF VK_MSG
                              VK_T_DATETIME].freeze
    CANCEL_MESSAGE_KEYS  = %w[VK_SERVICE VK_VERSION VK_SND_ID VK_REC_ID VK_STAMP
                              VK_REF VK_MSG].freeze

    def self.icon
      with_cache do
        AuctionCenter::Application.config
                                  .customization
                                  .dig(:payment_methods,
                                       config_namespace_name.to_sym,
                                       :icon)
      end
    end

    def seller_account
      AuctionCenter::Application.config
                                .customization
                                .dig(:payment_methods,
                                     self.class.config_namespace_name.to_sym,
                                     :seller_account)
    end

    def seller_private_key
      AuctionCenter::Application.config
                                .customization
                                .dig(:payment_methods,
                                     self.class.config_namespace_name.to_sym,
                                     :seller_private_key)
    end

    def bank_certificate
      AuctionCenter::Application.config
                                .customization
                                .dig(:payment_methods,
                                     self.class.config_namespace_name.to_sym,
                                     :bank_certificate)
    end

    def form_url
      AuctionCenter::Application.config
                                .customization
                                .dig(:payment_methods,
                                     self.class.config_namespace_name.to_sym,
                                     :url)
    end

    def form_fields
      hash = {}
      hash['VK_SERVICE']  = NEW_TRANSACTION_SERVICE_NUMBER
      hash['VK_VERSION']  = BANK_LINK_VERSION
      hash['VK_SND_ID']   = seller_account
      hash['VK_STAMP']    = id.to_s
      hash['VK_AMOUNT'] = invoices_total.format(symbol: nil,
                                                thousands_separator: false,
                                                decimal_mark: '.')
      hash['VK_CURR']     = Setting.find_by(code: 'auction_currency').retrieve
      hash['VK_REF']      = ''
      hash['VK_MSG']      = invoices.map(&:title).join(',').truncate(94, omission: '...')
      hash['VK_RETURN']   = return_url
      hash['VK_CANCEL']   = return_url
      hash['VK_DATETIME'] = Time.zone.now.strftime('%Y-%m-%dT%H:%M:%S%z')
      hash['VK_MAC']      = calc_mac(hash)
      hash['VK_ENCODING'] = 'UTF-8'
      hash['VK_LANG']     = language
      hash
    end

    def mark_invoice_as_paid
      if valid_response? && valid_success_notice?
        time = Time.zone.parse(response['VK_T_DATETIME'])
        paid!
        Invoice.transaction do
          invoices.each do |invoice|
            invoice.mark_as_paid_at_with_payment_order(time, self)
          end
        end
      elsif valid_response? && valid_cancel_notice?
        cancelled!
        false
      end
    end

    def valid_response?
      return false unless response

      case response['VK_SERVICE']
      when SUCCESSFUL_PAYMENT_SERVICE_NUMBER
        valid_successful_transaction?
      when CANCELLED_PAYMENT_SERVICE_NUMBER
        valid_cancel_notice?
      else
        false
      end
    end

    private

    def language
      if user&.locale == 'et'
        LANGUAGE_CODE_ET
      else
        LANGUAGE_CODE_EN
      end
    end

    def valid_successful_transaction?
      valid_success_notice? && valid_amount? && valid_currency?
    end

    def valid_success_notice?
      valid_mac?(response, SUCCESS_MESSAGE_KEYS)
    end

    def valid_cancel_notice?
      valid_mac?(response, CANCEL_MESSAGE_KEYS)
    end

    def valid_mac?(hash, keys)
      data = keys.map { |element| prepend_size(hash[element]) }.join
      verify_mac(data, hash['VK_MAC'])
    end

    def valid_amount?
      source = BigDecimal(response['VK_AMOUNT'])
      target = invoices_total.to_d

      source == target
    end

    def valid_currency?
      Setting.find_by(code: 'auction_currency').retrieve == response['VK_CURR']
    end

    def verify_mac(data, mac)
      bank_public_key = OpenSSL::X509::Certificate.new(File.read(bank_certificate)).public_key
      bank_public_key.verify(OpenSSL::Digest::SHA1.new, Base64.decode64(mac), data)
    end

    def calc_mac(fields)
      pars = NEW_MESSAGE_KEYS
      data = pars.map { |element| prepend_size(fields[element]) }.join
      sign(data)
    end

    def prepend_size(value)
      value = (value || '').to_s.strip
      string = ''
      string << format('%03i', value.size)
      string << value
    end

    def sign(data)
      private_key = OpenSSL::PKey::RSA.new(File.read(seller_private_key))
      signed_data = private_key.sign(OpenSSL::Digest::SHA1.new, data)
      signed_data = Base64.encode64(signed_data).gsub(/\n|\r/, '')
      signed_data
    end

    def invoices_total
      invoices.map(&:total).reduce(:+)
    end
  end
end
