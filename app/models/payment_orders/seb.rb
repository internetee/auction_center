module PaymentOrders
  class SEB < EstonianBankLink
    def self.config_namespace_name
      'seb'
    end
  end
end
