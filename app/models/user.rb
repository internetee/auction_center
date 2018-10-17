require 'identity_code'

class User < ApplicationRecord
  PARTICIPANT_ROLE = 'participant'.freeze
  ADMINISTATOR_ROLE = 'administrator'.freeze
  ROLES = %w[administrator participant].freeze

  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

  alias_attribute :country_code, :alpha_two_country_code

  validates :identity_code, presence: true, if: proc { |user| user.country_code == 'EE' }
  validates :identity_code, uniqueness: { scope: :alpha_two_country_code }
  validates :mobile_phone, presence: true

  validate :identity_code_must_be_valid_for_estonia

  has_many :billing_profiles, dependent: :delete_all

  def identity_code_must_be_valid_for_estonia
    return if IdentityCode.new(country_code, identity_code).valid?

    errors.add(:identity_code, I18n.t(:is_invalid))
  end

  def display_name
    "#{given_names} #{surname}"
  end

  def role?(role)
    roles.include?(role)
  end
end
