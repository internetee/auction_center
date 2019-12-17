class Setting < ApplicationRecord
  include Concerns::FormatValidator
  validates :code, presence: true, uniqueness: true
  validates :description, presence: true
  validates :value, presence: true

  def self.auction_currency
    Setting.find_by(code: :auction_currency).value
  end

  def self.auction_minimum_offer
    Setting.find_by(code: :auction_minimum_offer).value.to_i
  end

  def self.terms_and_conditions_link
    value = Setting.find_by(code: :terms_and_conditions_link).value
    JSON.parse(value)[I18n.locale.to_s]
  end

  def self.default_country
    Setting.find_by(code: :default_country).value
  end

  def self.payment_term
    Setting.find_by(code: :payment_term).value.to_i
  end

  def self.registration_term
    Setting.find_by(code: :registration_term).value.to_i
  end

  def self.auction_duration
    value = Setting.find_by(code: :auction_duration).value

    Setting.find_by(code: :auction_duration).value.to_i

    if value == 'end_of_day'
      :end_of_day
    else
      value.to_i
    end
  end

  def self.require_phone_confirmation
    value = Setting.find_by(code: :require_phone_confirmation).value

    if value == 'true'
      true
    elsif value == 'false'
      false
    end
  end

  def self.auctions_start_at
    value = Setting.find_by(code: :auctions_start_at).value

    if value == 'false'
      false
    else
      value.to_i
    end
  end

  def self.ban_length
    Setting.find_by(code: :ban_length).value.to_i
  end

  def self.ban_number_of_strikes
    Setting.find_by(code: :ban_number_of_strikes).value.to_i
  end

  def self.domain_registration_reminder_day
    Setting.find_by(code: :domain_registration_reminder).value.to_i
  end

  def self.invoice_issuer
    Setting.find_by(code: :invoice_issuer).value
  end

  def self.invoice_reminder_in_days
    Setting.find_by(code: :invoice_reminder_in_days).value.to_i
  end

  def self.wishlist_size
    Setting.find_by(code: :wishlist_size).value.to_i
  end

  def self.check_api_url
    Setting.find_by(code: :check_api_url)&.value
  end

  def self.check_sms_url
    Setting.find_by(code: :check_sms_url)&.value
  end

  def self.check_tara_url
    Setting.find_by(code: :check_tara_url)&.value
  end

  def self.violations_count_regulations_link
    hash = Setting.find_by(code: :violations_count_regulations_link)&.value
    hash.present? ? JSON.parse(hash).with_indifferent_access[I18n.locale] : nil
  end

  def self.wishlist_supported_domain_extensions
    extensions = Setting.find_by(code: :wishlist_supported_domain_extensions)
    extensions.present? ? JSON.parse(extensions.value) : []
  end
end
