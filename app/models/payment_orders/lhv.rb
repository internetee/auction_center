module PaymentOrders
  class LHV < EstonianBankLink
    def self.config_namespace_name
      'lhv'
    end
  end
end
