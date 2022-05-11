require 'identity_code'

class User < ApplicationRecord
  include Concerns::Bannable
  PARTICIPANT_ROLE = 'participant'.freeze
  ADMINISTATOR_ROLE = 'administrator'.freeze
  ROLES = %w[administrator participant].freeze

  ESTONIAN_COUNTRY_CODE = 'EE'.freeze
  TARA_PROVIDER = 'tara'.freeze

  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable,
         :timeoutable

  alias_attribute :country_code, :alpha_two_country_code

  validates :identity_code, uniqueness: { scope: :alpha_two_country_code }, allow_blank: true
  validate :identity_code_must_be_valid_for_estonia, if: proc { |user|
    user.country_code.present? && user.identity_code.present?
  }
  validates :mobile_phone, presence: true, unless: proc { |user|
    user.provider == TARA_PROVIDER
  }
  validates :mobile_phone, format: { with: /\A\+[1-9]{1}[0-9]{3,14}\z/ }, unless: proc { |user|
    user.provider == TARA_PROVIDER
  }

  validate :mobile_phone_must_not_be_already_confirmed, unless: proc { |user|
    user.provider == TARA_PROVIDER
  }

  validates :given_names, :surname, safe_value: true

  validates :given_names, presence: true
  validates :surname, presence: true
  validate :participant_must_accept_terms_and_conditions

  has_many :billing_profiles, dependent: :nullify
  has_many :payment_orders, dependent: :nullify
  has_many :offers, dependent: :nullify
  has_many :results, dependent: :nullify
  has_many :invoices, dependent: :nullify
  has_many :bans, dependent: :destroy
  has_many :wishlist_items, dependent: :destroy

  scope :subscribed_to_daily_summary, -> { where(daily_summary: true) }
  scope :with_confirmed_phone, -> { where.not(mobile_phone_confirmed_at: nil) }

  def identity_code_must_be_valid_for_estonia
    return if IdentityCode.new(country_code, identity_code).valid?

    errors.add(:identity_code, I18n.t(:is_invalid))
  end

  def participant_must_accept_terms_and_conditions
    return if terms_and_conditions_accepted_at.present?

    errors.add(:terms_and_conditions, I18n.t('users.must_accept_terms_and_conditions'))
  end

  def accepts_terms_and_conditions=(acceptance)
    acceptance_as_bool = ActiveRecord::Type::Boolean.new.cast(acceptance)
    new_terms_and_conditions_accepted_at = if acceptance_as_bool
                                             terms_and_conditions_accepted_at || Time.now.utc
                                           end
    self.terms_and_conditions_accepted_at = new_terms_and_conditions_accepted_at
  end

  def accepts_terms_and_conditions
    terms_and_conditions_accepted_at.present?
  end

  def display_name
    "#{given_names} #{surname}"
  end

  def role?(role)
    roles.include?(role)
  end

  def deletable?
    invoices&.issued&.blank?
  end

  def signed_in_with_identity_document?
    provider == TARA_PROVIDER && uid.present?
  end

  def requires_phone_number_confirmation?
    if Setting.find_by(code: 'require_phone_confirmation').retrieve
      return false if signed_in_with_identity_document?
      return false if phone_number_confirmed?

      true
    else
      false
    end
  end

  def requires_captcha?
    !signed_in_with_identity_document?
  end

  def completely_banned?
    num_of_strikes = Setting.find_by(code: 'ban_number_of_strikes').retrieve
    bans_count = bans.valid.size
    bans_count >= num_of_strikes
  end

  def phone_number_confirmed?
    mobile_phone_confirmed_at.present?
  end

  def not_phone_number_confirmed_unique?
    !phone_number_confirmed_unique?
  end

  def phone_number_confirmed_unique?
    return true if provider == TARA_PROVIDER
    return true unless Setting.find_by(code: 'require_phone_confirmation').retrieve

    !phone_number_was_already_confirmed?
  end

  def phone_number_was_already_confirmed?
    User.where(mobile_phone: mobile_phone)
        .where.not(id: id)
        .with_confirmed_phone
        .present?
  end

  def banned?
    Ban.where(user_id: id).valid.any?
  end

  def longest_ban
    strikes = Setting.find_by(code: 'ban_number_of_strikes').retrieve
    Ban.valid.where(user_id: id).order(valid_until: :desc).limit(strikes).last
  end

  # Make sure that notifications are send asynchronously
  def send_devise_notification(notification, *args)
    I18n.with_locale(locale) do
      devise_mailer.send(notification, self, *args).deliver_later
    end
  end

  def tampered_with?(omniauth_hash)
    uid_from_hash = omniauth_hash['uid']
    provider_from_hash = omniauth_hash['provider']

    begin
      uid != uid_from_hash ||
        provider != provider_from_hash ||
        country_code != uid_from_hash.slice(0..1) ||
        identity_code != uid_from_hash.slice(2..-1) ||
        given_names != omniauth_hash.dig('info', 'first_name') ||
        surname != omniauth_hash.dig('info', 'last_name')
    end
  end

  def self.from_omniauth(omniauth_hash)
    uid = omniauth_hash['uid']
    provider = omniauth_hash['provider']

    user = User.find_or_initialize_by(identity_code: uid[2..])
    user.provider = provider
    user.uid = uid
    user.given_names = omniauth_hash.dig('info', 'first_name')
    user.surname = omniauth_hash.dig('info', 'last_name')
    user.country_code = uid.slice(0..1)
    user.save if user.valid?

    user
  end

  def mobile_phone_must_not_be_already_confirmed
    errors.add(:mobile_phone, I18n.t(:already_confirmed)) if phone_number_was_already_confirmed?
  end
end
