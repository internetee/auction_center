# rubocop:disable Metrics/ClassLength
require 'result_not_found'
require 'result_not_sold'
require 'countries'

class Invoice < ApplicationRecord
  include Concerns::Invoice::BookKeeping
  include Concerns::Invoice::Payable
  include Concerns::Invoice::Linkpayable

  alias_attribute :country_code, :alpha_two_country_code
  enum status: { issued: 'issued', paid: 'paid', cancelled: 'cancelled' }

  belongs_to :result, optional: false
  belongs_to :user, optional: true
  belongs_to :billing_profile, optional: true
  has_many :invoice_items, dependent: :destroy
  has_many :invoice_payment_orders, dependent: :destroy
  has_many :payment_orders, through: :invoice_payment_orders
  belongs_to :paid_with_payment_order, class_name: 'PaymentOrder', optional: true

  validates :user_id, presence: true, on: :create
  validates :issue_date, :due_date, presence: true
  validates :paid_at, presence: true, if: proc { |invoice| invoice.paid? }
  validates :cents, numericality: { only_integer: true, greater_than: 0 }
  validates :billing_profile, presence: true, on: :create

  validate :user_id_must_be_the_same_as_on_billing_profile_or_nil
  before_update :update_billing_address

  before_create :set_invoice_number

  delegate :enable_deposit?, to: :enable_deposit?
  delegate :deposit, to: :deposit

  scope :with_search_scope, (lambda do |origin|
    if origin.present?
      if numeric?(origin)
        where('number = ?', origin)
      else
        joins(:user)
        .joins(:billing_profile)
        .joins(:invoice_items)
        .where('billing_profiles.name ILIKE ? OR ' \
                'users.email ILIKE ? OR users.surname ILIKE ? OR ' \
                'invoice_items.name ILIKE ?',
                "%#{origin}%",
                "%#{origin}%",
                "%#{origin}%",
                "%#{origin}%")
      end
    end
  end)

  scope :with_statuses, (lambda do |statuses|
    where(status: [statuses]) if statuses.present?
  end)

  scope :overdue, -> { where('due_date < ? AND status = ?', Time.zone.today, statuses[:issued]) }

  scope :pending_payment_reminder,
        lambda { |number_of_days = Setting.find_by(code: 'invoice_reminder_in_days').retrieve|
          where('due_date = ? AND status = ?',
                Time.zone.today + number_of_days, statuses[:issued])
        }

  def self.search(params = {})
    with_search_scope(params[:search_string]).with_statuses(params[:statuses_contains])
  end

  def self.create_from_result(result_id)
    result = Result.find_by(id: result_id)

    raise(Errors::ResultNotFound, result_id) unless result
    raise(Errors::ResultNotSold, result_id) unless result.awaiting_payment?

    InvoiceCreator.new(result_id).call
  end

  def enable_deposit?
    result.auction.enable_deposit?
  end

  def deposit
    result.auction.deposit
  end

  def billing_restrictions_issue
    errors.add(:base, I18n.t('cannot get access'))
    logger.error('PROBLEM WITH TOKEN')
    throw(:abort)
  end

  def billing_out_of_range_issue
    errors.add(:base, I18n.t('failed_to_generate_invoice_invoice_number_limit_reached'))
    logger.error('INVOICE NUMBER LIMIT REACHED, COULD NOT GENERATE INVOICE')
    throw(:abort)
  end

  def set_invoice_number
    invoice_number = EisBilling::GetInvoiceNumber.call

    if invoice_number.result?
      self.number = invoice_number.instance['invoice_number'].to_i
    else
      billing_restrictions_issue if invoice_number.errors['code'] == '403'
      billing_out_of_range_issue if invoice_number.errors['error'] == 'out of range'
    end
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

  def auction_currency
    Rails.cache.fetch(cache_key_with_version, expires_in: 12.hours) do
      Setting.find_by(code: 'auction_currency').retrieve
    end
  end

  def price
    Money.new(cents, auction_currency)
  end

  def total
    (price * (1 + vat_rate)).round(2)
  end

  def vat
    price * vat_rate
  end

  def title
    persisted? ? I18n.t('invoices.title', number: number) : nil
  end

  def address
    country_name = Countries.name_from_alpha2_code(country_code)
    postal_code_with_city = [postal_code, city].join(' ')
    [street, postal_code_with_city, country_name].compact.join(', ')
  end

  def vat_rate
    return Countries.vat_rate_from_alpha2_code(country_code) if country_code == 'EE'
    return BigDecimal('0') if vat_code.present?

    Countries.vat_rate_from_alpha2_code(country_code)
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
      prepare_payment_fields(time)

      result.mark_as_payment_received(time) unless cancelled?
      clear_linked_ban
      paid!
    end
    ResultStatusUpdateJob.perform_now
  end

  def mark_as_paid_at_with_payment_order(time, payment_order)
    ActiveRecord::Base.transaction do
      prepare_payment_fields(time)
      self.paid_with_payment_order = payment_order

      result.mark_as_payment_received(time) unless cancelled?
      clear_linked_ban
      paid!
    end
    ResultStatusUpdateJob.perform_now
  end

  def overdue?
    due_date < Time.zone.today && issued?
  end

  def update_billing_address
    return if billing_profile.blank?

    billing_fields = %w[vat_code street city postal_code alpha_two_country_code]
    self.recipient = billing_profile.name

    billing_profile.attributes.keys.each do |attribute|
      self[attribute] = billing_profile[attribute] if billing_fields.include? attribute
    end
  end

  def self.with_billing_profile(billing_profile_id:)
    Invoice.where(billing_profile_id: billing_profile_id)
  end

  def self.numeric?(string)
    return true if string =~ /\A\d+\Z/

    begin
      true if Float(string)
    rescue StandardError
      false
    end
  end

  private

  def clear_linked_ban
    ban = Ban.find_by(invoice_id: id)
    ban.lift if ban.present?
  end

  def prepare_payment_fields(time)
    self.paid_at = time
    self.vat_rate = billing_profile.present? ? billing_profile.vat_rate : vat_rate
    self.paid_amount = total
  end
end
# rubocop:enable Metrics/ClassLength
