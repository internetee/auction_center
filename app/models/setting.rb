class Setting < ApplicationRecord
  include Concerns::FormatValidator
  validates :code, presence: true, uniqueness: true
  validates :description, presence: true
  validates :value, presence: true
  validates :value_format, presence: true
  validate :valid_value_format

  VALUE_FORMATS = {
    string: :string_format,
    integer: :integer_format,
    boolean: :boolean_format,
    hash: :hash_format,
    array: :array_format,
  }.with_indifferent_access.freeze

  def retrieve
    method = VALUE_FORMATS[value_format]
    send(method)
  end

  def valid_value_format
    formats = VALUE_FORMATS.with_indifferent_access
    errors.add(:value_format, :invalid) unless formats.keys.any? value_format
  end

  def string_format
    return auction_duration_value if code == 'auction_duration'
    return auctions_start_at_value if code == 'auctions_start_at'

    value
  end

  def integer_format
    value.to_i
  end

  def boolean_format
    value == 'true'
  end

  def hash_format
    if %w[terms_and_conditions_link violations_count_regulations_link].include? code
      return localized_hash_value
    end

    JSON.parse(value)
  end

  def localized_hash_value
    JSON.parse(value)[I18n.locale.to_s]
  end

  def array_format
    JSON.parse(value).to_a
  end

  def auction_duration_value
    if value == 'end_of_day'
      :end_of_day
    else
      value.to_i
    end
  end

  def auctions_start_at_value
    if value == 'false'
      false
    else
      value.to_i
    end
  end
<<<<<<< HEAD
=======

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

  def self.remind_on_domain_registration_everyday
    value = Setting.find_by(code: :remind_on_domain_registration_everyday).value

    value == 'true'
  end
>>>>>>> Add setting for remind on domain registration every day
end
