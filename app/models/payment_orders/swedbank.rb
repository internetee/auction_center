module PaymentOrders
  class Swedbank < EstonianBankLink
    def self.config_namespace_name
      'swedbank'
    end
  end
end
