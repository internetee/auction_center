require 'expected_payment_order'

class PaymentOrder < ApplicationRecord
  ENABLED_METHODS = AuctionCenter::Application.config
                                              .customization
                                              .dig('payment_methods', 'enabled_methods')


  enum status: { issued: 'issued',
                 paid: 'paid',
                 cancelled: 'cancelled' }

  validates :user_id, presence: true, on: :create
  validates :type, inclusion: { in: ENABLED_METHODS }

  validate :invoice_cannot_be_already_paid, on: :create

  belongs_to :invoice, required: true
  belongs_to :user, required: false

  def invoice_cannot_be_already_paid
    return unless invoice&.paid?

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

  attr_writer :callback_url
  attr_reader :callback_url

  attr_writer :return_url
  attr_reader :return_url
end
