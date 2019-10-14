class Setting < ApplicationRecord
  validates :code, presence: true
  validates :description, presence: true
  validates :value, presence: true
  validates :code, uniqueness: true
  validate :valid_format_for_wishlist_domain_extensions, on: %i[create update]
  validate :supported_default_wishlist_domain_extension, on: %i[create update]

  def self.auction_currency
    Setting.find_by(code: :auction_currency).value
  end

  def self.auction_minimum_offer
    Setting.find_by(code: :auction_minimum_offer).value.to_i
  end

  def self.terms_and_conditions_link
    Setting.find_by(code: :terms_and_conditions_link).value
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

  def self.wishlist_supported_domain_extensions
    extensions = Setting.find_by(code: :wishlist_supported_domain_extensions)
    if extensions.present?
      return JSON.parse(extensions.value) if json_array?(extensions.value)
    end

    []
  end

  def self.wishlist_default_domain_extension
    default_domain = Setting.find_by(code: :wishlist_default_domain_extension)
    return default_domain.value if default_domain.present?

    nil
  end
end

private
def valid_format_for_wishlist_domain_extensions
  return unless code == 'wishlist_supported_domain_extensions'

  r = /\A([a-z0-9\-\u00E4\u00F5\u00F6\u00FC\u0161\u017E]{1,61}\.)?[a-z0-9]{1,61}\z/x
  err = false
  if json_array?(value)
    JSON.parse(value).each do |ext|
      err = true unless ext.match?(r)
    end
    return if err == false
  end

  errors.add(:value, 'is invalid')
end

def supported_default_wishlist_domain_extension
  return unless code == 'wishlist_default_domain_extension'
  return if Setting.wishlist_supported_domain_extensions.empty?
  return if Setting.wishlist_supported_domain_extensions.include?(value)

  errors.add(:value, 'is invalid')
end

def json_array?(text)
  JSON.parse(text).is_a?(Array)
rescue JSON::ParserError
  false
rescue NoMethodError
  false
end