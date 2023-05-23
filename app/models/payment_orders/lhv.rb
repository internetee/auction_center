module PaymentOrders
  class Lhv < EstonianBankLink
    def self.config_namespace_name
      'lhv'
    end
  end
end
