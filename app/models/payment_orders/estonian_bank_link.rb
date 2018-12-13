module PaymentOrders
  class EstonianBankLink < PaymentOrder
    BANK_LINK_VERSION = '008'

    NEW_TRANSACTION_SERVICE_NUMBER    = '1012'
    SUCCESSFUL_PAYMENT_SERVICE_NUMBER = '1111'
    CANCELLED_PAYMENT_SERVICE_NUMBER  = '1911'

    NEW_MESSAGE_KEYS     = %w(VK_SERVICE VK_VERSION VK_SND_ID VK_STAMP VK_AMOUNT
                              VK_CURR VK_REF VK_MSG VK_RETURN VK_CANCEL
                              VK_DATETIME).freeze
    SUCCESS_MESSAGE_KEYS = %w(VK_SERVICE VK_VERSION VK_SND_ID VK_REC_ID VK_STAMP
                              VK_T_NO VK_AMOUNT VK_CURR VK_REC_ACC VK_REC_NAME
                              VK_SND_ACC VK_SND_NAME VK_REF VK_MSG
                              VK_T_DATETIME).freeze
    CANCEL_MESSAGE_KEYS  = %w(VK_SERVICE VK_VERSION VK_SND_ID VK_REC_ID VK_STAMP
                            VK_REF VK_MSG).freeze

    # Name of configuration namespace
    def self.config_namespace_name; end

    def self.icon
      AuctionCenter::Application.config
                                .customization
                                .dig('payment_methods',
                                     self.config_namespace_name,
                                     'icon')
    end

    def seller_account
      AuctionCenter::Application.config
                                .customization
                                .dig('payment_methods',
                                     self.class.config_namespace_name,
                                     'seller_account')
    end

    def seller_private_key
      AuctionCenter::Application.config
                                .customization
                                .dig('payment_methods',
                                     self.class.config_namespace_name,
                                     'seller_private_key')
    end

    def bank_certificate
      AuctionCenter::Application.config
                                .customization
                                .dig('payment_methods',
                                     self.class.config_namespace_name,
                                     'bank_certificate')
    end

    def form_url
      AuctionCenter::Application.config
                                .customization
                                .dig('payment_methods',
                                     self.class.config_namespace_name,
                                     'url')
    end

    def form_fields
      hash = {}
      hash["VK_SERVICE"]  = NEW_TRANSACTION_SERVICE_NUMBER
      hash["VK_VERSION"]  = BANK_LINK_VERSION
      hash["VK_SND_ID"]   = seller_account
      hash["VK_STAMP"]    = invoice.number
      hash["VK_AMOUNT"]   = invoice.total.to_s
      hash["VK_CURR"]     = invoice.currency
      hash["VK_REF"]      = ""
      hash["VK_MSG"]      = invoice.order
      hash["VK_RETURN"]   = return_url
      hash["VK_CANCEL"]   = return_url
      hash["VK_DATETIME"] = Time.zone.now.strftime("%Y-%m-%dT%H:%M:%S%z")
      hash["VK_MAC"]      = calc_mac(hash)
      hash["VK_ENCODING"] = "UTF-8"
      hash["VK_LANG"]     = "ENG"
      hash
    end
  end
end
