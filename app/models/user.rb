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

  validate :identity_code_must_be_valid_for_estonia
  validate :participant_must_accept_terms_and_conditions

  has_many :billing_profiles, dependent: :delete_all
  has_many :offers, dependent: :delete_all

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
    if acceptance_as_bool
      self.terms_and_conditions_accepted_at = Time.now.utc
    else
      self.terms_and_conditions_accepted_at = nil
    end
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
end
