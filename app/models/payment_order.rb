class PaymentOrder < ApplicationRecord
  ENABLED_METHODS = AuctionCenter::Application.config
                                              .customization
                                              .dig(:payment_methods, :enabled_methods)

  enum status: { issued: 'issued',
                 paid: 'paid',
                 cancelled: 'cancelled' }

  validates :user_id, presence: true, on: :create
  validates :type, inclusion: { in: ENABLED_METHODS }

  validate :invoice_cannot_be_already_paid, on: :create

  has_many :invoice_payment_orders, dependent: :destroy
  has_many :invoices, through: :invoice_payment_orders
  belongs_to :user, optional: true

  attr_writer :callback_url
  attr_reader :callback_url

  attr_writer :return_url
  attr_reader :return_url

  scope :every_pay, -> { where('type = ?', 'PaymentOrders::EveryPay') }
  scope :for_payment_reference, ->(ref) { where("response->>'payment_reference'=?", ref) }

  # Name of configuration namespace
  def self.config_namespace_name; end

  def invoice_cannot_be_already_paid
    return unless invoices.any?(&:paid?)

    errors.add(:invoice, 'is already paid')
  end

  def self.supported_method?(some_class)
    raise(Errors::ExpectedPaymentOrder, some_class) unless some_class < PaymentOrder

    if ENABLED_METHODS.include?(some_class.name)
      true
    else
      false
    end
  end

  def self.with_cache
    Rails.cache.fetch("#{new.cache_key}/#{config_namespace_name}_icon",
                      expires_in: 12.hours) do
      yield if block_given?
    end
  end

  def channel
    type.gsub('PaymentOrders::', '')
  end

  # def self.supported_methods
  #   enabled = []

  #   ENABLED_METHODS.each do |method|
  #     class_name = method.constantize
  #     raise(Errors::ExpectedPaymentOrder, class_name) unless class_name < PaymentOrder

  #     enabled << class_name
  #   end

  #   enabled
  # end
end
