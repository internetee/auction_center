require 'identity_code'

class User < ApplicationRecord
  include Bannable
  include ReferenceNo

  PARTICIPANT_ROLE = 'participant'.freeze
  ADMINISTATOR_ROLE = 'administrator'.freeze
  ROLES = %w[administrator participant].freeze

  ESTONIAN_COUNTRY_CODE = 'EE'.freeze
  TARA_PROVIDER = 'tara'.freeze
  EEID_PROVIDER = 'eeid'.freeze
  IDENTITY_DOCUMENT_PROVIDERS = [TARA_PROVIDER, EEID_PROVIDER].freeze
  # eeID subjects from eIDAS carry the ETSI "PNO<country>-" prefix, e.g. "PNOLV-123456-12345".
  EIDAS_SUBJECT_PREFIX = /\APNO([A-Z]{2})-/

  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable,
         :timeoutable

  alias_attribute :country_code, :alpha_two_country_code

  validates :identity_code, uniqueness: { scope: :alpha_two_country_code }, allow_blank: true
  validate :identity_code_must_be_valid_for_estonia, if: proc { |user|
    user.country_code.present? && user.identity_code.present?
  }
  validates :mobile_phone, presence: true, unless: :identity_document_provider?
  validates :mobile_phone, format: { with: /\A\+[1-9]{1}[0-9]{3,14}\z/ },
                           unless: :identity_document_provider?

  validate :mobile_phone_must_not_be_already_confirmed, unless: :identity_document_provider?

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
  has_many :autobiders, dependent: :destroy
  has_many :domain_participate_auctions
  has_many :notifications, as: :recipient, dependent: :destroy

  has_one :webpush_subscription

  scope :subscribed_to_daily_summary, -> { where(daily_summary: true) }
  scope :with_confirmed_phone, -> { where.not(mobile_phone_confirmed_at: nil) }

  scope :with_search_scope, ->(origin) {
    if origin.present?
      self.where('email ILIKE ? OR surname ILIKE ? OR given_names ILIKE ? ' \
                 'OR mobile_phone ILIKE ?',
                 "%#{origin}%",
                 "%#{origin}%",
                 "%#{origin}%",
                 "%#{origin}%")
    end
  }

  scope :with_deposit_participants, ->(enable, auction_id) do
    if enable.present?
      self.includes(:domain_participate_auctions).where(domain_participate_auctions: { auction_id: auction_id })
    end
  end

  scope :without_deposit_participants, ->(enable, auction_id) do
    if enable.present?
      self.includes(:domain_participate_auctions).where.not(domain_participate_auctions: { auction_id: auction_id })
    end
  end

  def self.search(params = {})
    self.with_search_scope(params[:search_string])
  end

  def self.search_deposit_participants(params = {})
    self.with_search_scope(params[:search_string])
        .with_deposit_participants(params[:with_deposit_participants],
                                   params[:auction_id])
        .without_deposit_participants(params[:without_deposit_participants],
                                      params[:auction_id])
  end

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

  def identity_document_provider?
    IDENTITY_DOCUMENT_PROVIDERS.include?(provider)
  end

  def signed_in_with_identity_document?
    identity_document_provider? && uid.present?
  end

  def tara_user_with_unconfirmed_email?
    signed_in_with_identity_document? && confirmed_at.blank?
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
    return true if identity_document_provider?
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
    country_code_from_hash, identity_code_from_hash = User.split_identity_uid(uid_from_hash, provider_from_hash)

    uid != uid_from_hash ||
      provider != provider_from_hash ||
      country_code != country_code_from_hash ||
      identity_code != identity_code_from_hash ||
      given_names != omniauth_hash.dig('info', 'first_name') ||
      surname != omniauth_hash.dig('info', 'last_name')
  end

  # Returns [country_code, identity_code] for an identity provider subject such as
  # "EE38001085718" (TARA and eeID) or "PNOLV-123456-12345" (eeID via eIDAS).
  def self.split_identity_uid(uid, provider)
    match = EIDAS_SUBJECT_PREFIX.match(uid) if provider == EEID_PROVIDER
    return [match[1], match.post_match] if match

    [uid.slice(0..1), uid[2..]]
  end

  # Estonian identity codes are looked up regardless of the stored country, as before;
  # foreign codes (e.g. document numbers from eeID identity verification) are only
  # unique within their country.
  def self.from_omniauth(omniauth_hash)
    uid = omniauth_hash['uid']
    provider = omniauth_hash['provider']
    country_code, identity_code = split_identity_uid(uid, provider)

    lookup = { identity_code: identity_code }
    lookup[:alpha_two_country_code] = country_code unless country_code == ESTONIAN_COUNTRY_CODE

    user = User.find_or_initialize_by(lookup)
    user.provider = provider
    user.uid = uid
    user.given_names = omniauth_hash.dig('info', 'first_name')
    user.surname = omniauth_hash.dig('info', 'last_name')
    user.country_code = country_code
    user.save if user.valid?

    user
  end

  def mobile_phone_must_not_be_already_confirmed
    errors.add(:mobile_phone, I18n.t(:already_confirmed)) if phone_number_was_already_confirmed?
  end

  def participated_in_english_auction?(auction)
    return false unless auction.english?

    auction.offers.any? { |offer| offer.user == self } || auction.domain_participate_auctions.any? { |p| p.user == self }
  end

  def allow_to_send_sms_again?
    return true if mobile_phone_confirmed_sms_send_at.blank?

    mobile_phone_confirmed_sms_send_at < PhoneConfirmation::TIME_LIMIT.ago
  end

  def active_for_authentication?
    signed_in_with_identity_document? || super
  end
end
