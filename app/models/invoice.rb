require 'result_not_found'
require 'result_not_sold'

class Invoice < ApplicationRecord
  enum status: { issued: 'issued',
                 paid: 'paid',
                 cancelled: 'cancelled' }

  belongs_to :result, optional: false
  belongs_to :user, optional: true
  belongs_to :billing_profile, optional: false
  has_many :invoice_items, dependent: :destroy
  has_many :payment_orders, dependent: :destroy
  belongs_to :paid_with_payment_order, class_name: 'PaymentOrder', optional: true

  validates :user_id, presence: true, on: :create
  validates :issue_date, presence: true
  validates :due_date, presence: true
  validates :paid_at, presence: true, if: proc { |invoice| invoice.paid? }
  validates :cents, numericality: { only_integer: true, greater_than: 0 }

  validate :user_id_must_be_the_same_as_on_billing_profile_or_nil

  scope :overdue, lambda {
    where('due_date < ? AND status = ?', Time.zone.today, statuses[:issued])
  }

  scope :pending_payment_reminder, lambda { |number_of_days = Setting.invoice_reminder_in_days|
    where('due_date = ? AND status = ?',
          Time.zone.today + number_of_days,
          statuses[:issued])
  }

  def self.create_from_result(result_id)
    result = Result.find_by(id: result_id)

    raise(Errors::ResultNotFound, result_id) unless result
    raise(Errors::ResultNotSold, result_id) unless result.awaiting_payment?

    InvoiceCreator.new(result_id).call
  end

  def items
    invoice_items
  end

  def items=(items)
    self.invoice_items = items
  end

  def user_id_must_be_the_same_as_on_billing_profile_or_nil
    return unless billing_profile
    return unless user

    return if billing_profile.user_id == user_id

    errors.add(:billing_profile, I18n.t('invoices.billing_profile_must_belong_to_user'))
  end

  def price
    Money.new(cents, Setting.auction_currency)
  end

  def total
    price * (1 + billing_profile.vat_rate)
  end

  def vat
    price * billing_profile.vat_rate
  end

  def title
    return unless persisted?

    I18n.t('invoices.title', number: number)
  end

  def filename
    return unless title

    "#{title.parameterize}.pdf"
  end

  # mark_as_paid_at_with_payment_order(time, payment_order) is the preferred version to use
  # in the application, but this is also used with administrator manually setting invoice as
  # paid in the user interface.
  def mark_as_paid_at(time)
    ActiveRecord::Base.transaction do
      self.paid_at = time
      self.vat_rate = billing_profile.vat_rate
      self.total_amount = total

      paid!
      result.mark_as_payment_received(time)
    end
  end

  def mark_as_paid_at_with_payment_order(time, payment_order)
    ActiveRecord::Base.transaction do
      self.paid_at = time
      self.vat_rate = billing_profile.vat_rate
      self.total_amount = total
      self.paid_with_payment_order = payment_order

      paid!
      result.mark_as_payment_received(time)
    end
  end

  def overdue?
    due_date < Time.zone.today && issued?
  end
end
