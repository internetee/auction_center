require 'countries'

class BillingProfile < ApplicationRecord
  OLD_EST_RATE_VAT = '0.2'.freeze

  alias_attribute :country_code, :alpha_two_country_code

  validates :name, presence: true
  validates :country_code, presence: true
  validates :vat_code, uniqueness: { scope: :user_id }, allow_blank: true
  validate :vat_code_must_be_registered_in_vies

  validates :name, :vat_code, :street, :city, :postal_code, safe_value: true

  belongs_to :user, optional: true
  after_update :mirror_address_to_attached_invoices
  before_update :update_billing_information_for_invoices

  has_many :domain_offer_histories
  has_many :invoices

  scope :with_search_scope, lambda { |origin|
    if origin.present?
      joins(:user)
        .includes(:user)
        .where(
          'billing_profiles.name ILIKE ? OR ' \
          'users.email ILIKE ? OR users.surname ILIKE ?',
          "%#{origin}%",
          "%#{origin}%",
          "%#{origin}%"
        )
    end
  }

  def self.search(params = {})
    with_search_scope(params[:search_string])
  end

  def vat_code_must_be_registered_in_vies
    # Vat code validation only for EU countries
    vat_rate = Countries.vat_rate_from_alpha2_code(country_code)
    return if vat_code.blank? || vat_rate == BigDecimal(0)

    errors.add(:vat_code, I18n.t('billing_profiles.vat_validation_error')) unless Valvat.new(vat_code).exists?
  rescue Valvat::RateLimitError
    errors.add(:vat_code, I18n.t('billing_profiles.vat_validation_rate_limit_error'))
  rescue Valvat::MemberStateUnavailable, Valvat::ServiceUnavailable
    errors.add(:vat_code, I18n.t('billing_profiles.vat_validation_service_unavailable'))
  end

  def issued_invoices
    invoices.where(status: 'issued')
  end

  def user_name
    user ? user.display_name : I18n.t('billing_profiles.orphaned')
  end

  def address
    country_name = Countries.name_from_alpha2_code(country_code)
    postal_code_with_city = [postal_code, city].join(' ')
    [street, postal_code_with_city, country_name].compact.join(', ')
  end

  def vat_rate
    # return Countries.vat_rate_from_alpha2_code(country_code) if country_code == 'EE'
    # return BigDecimal(Setting.find_by(code: :estonian_vat_rate).retrieve, 2) if country_code == 'EE'

    if country_code == 'EE'
      # if Time.zone.now.year < 2024
      #   return BigDecimal(OLD_EST_RATE_VAT)
      # else
      return BigDecimal(Setting.find_by(code: :estonian_vat_rate).retrieve, 2)
      # end
    end

    return BigDecimal('0') if vat_code.present?

    Countries.vat_rate_from_alpha2_code(country_code)
  end

  def self.create_default_for_user(user_id)
    return if find_by(user_id:)

    user = User.find(user_id)

    billing_profile = new(user:, country_code: user.country_code, name: user.display_name)
    billing_profile.save!

    billing_profile
  end

  def unfinished_offers
    offers = []
    Offer.where(billing_profile_id: id).find_each do |offer|
      offers << offer if offer.auction.result&.invoice.blank?
    end
    offers
  end

  def deletable?
    return true unless unfinished_offers.any?

    errors.add :name, I18n.t('billing_profiles.in_use_by_offer')
    false
  end

  def mirror_address_to_attached_invoices
    return unless Invoice.with_billing_profile(billing_profile_id: id).any?

    Invoice.with_billing_profile(billing_profile_id: id).find_each do |invoice|
      next if invoice.paid?

      invoice.update_billing_info
      invoice.save!
    end
  end

  private

  def update_billing_information_for_invoices
    return unless name_changed? || street_changed? || city_changed? || postal_code_changed? || country_code_changed?

    issued_invoices.update_all(
      billing_name: name,
      billing_address: address,
      billing_vat_code: vat_code,
      billing_alpha_two_country_code: alpha_two_country_code
    )
  end
end
