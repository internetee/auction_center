class PaymentOrder < ApplicationRecord
  enum status: { issued: 'issued',
                 in_progress: 'in_progress',
                 paid: 'paid',
                 cancelled: 'cancelled' }

  belongs_to :invoice, required: true
  belongs_to :user, required: false

  validates :user_id, presence: true, on: :create

  attr_writer :callback_url
  attr_reader :callback_url

  attr_writer :return_url
  attr_reader :return_url
end
