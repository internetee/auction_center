require 'identity_code'

class User < ApplicationRecord
  PARTICIPANT_ROLE = 'participant'.freeze
  ADMINISTATOR_ROLE = 'administrator'.freeze
  ROLES = %w[administrator participant].freeze

  ESTONIAN_COUNTRY_CODE = 'EE'.freeze

  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

  alias_attribute :country_code, :alpha_two_country_code

  validates :identity_code, presence: true, if: proc { |user|
    user.country_code == ESTONIAN_COUNTRY_CODE
  }

  validates :identity_code, uniqueness: { scope: :alpha_two_country_code }
  validates :mobile_phone, presence: true
  validates :given_names, presence: true
  validates :surname, presence: true

  validate :identity_code_must_be_valid_for_estonia
  validate :participant_must_accept_terms_and_conditions

  has_many :billing_profiles, dependent: :nullify
  has_many :offers, dependent: :nullify
  has_many :results, dependent: :nullify
  has_many :invoices, dependent: :nullify

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

  def phone_number_confirmed?
    phone_number_confirmed_at.present?
  end

  # Make sure that notifications are send asynchronously
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
