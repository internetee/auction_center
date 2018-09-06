class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

  alias_attribute :country_code, :alpha_two_country_code

  validates :identity_code, uniqueness: { scope: :alpha_two_country_code }

  validates :identity_code, presence: true
  validates :mobile_phone, presence: true

  def display_name
    "#{given_names} #{surname}"
  end
end
