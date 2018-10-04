class BillingProfile < ApplicationRecord
  belongs_to :user, required: true

  validates :street, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true

  validates :vat_code, presence: true, if: Proc.new {|i| i.legal_entity }

  def address
    postal_code_with_city = [postal_code, city].join(' ')
    [street, postal_code_with_city, state, country].compact.join(', ')
  end

  def user_name
    user.display_name
  end
end
