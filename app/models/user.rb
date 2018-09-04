class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

  alias_attribute :country_code, :alpha_two_country_code

  def display_name
    "#{given_names} #{surname}"
  end
end
