require 'countries'

class BillingProfile < ApplicationRecord
  alias_attribute :country_code, :alpha_two_country_code

  validates :street, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country_code, presence: true

  validates :name, presence: true
  validates :vat_code, uniqueness: { scope: :user_id }, allow_blank: true

  belongs_to :user, required: false

  def address
    country_name = Countries.name_from_alpha2_code(country_code)
    postal_code_with_city = [postal_code, city].join(' ')
    [street, postal_code_with_city, state, country_name].compact.join(', ')
  end

  def user_name
    if user
      user.display_name
    else
      I18n.t('billing_profiles.orphaned')
    end
  end

  def vat_rate
    if vat_code.present?
      BigDecimal('0')
    else
      Countries.vat_rate_from_alpha2_code(country_code)
    end
  end
end
