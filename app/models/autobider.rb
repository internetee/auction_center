class Autobider < ApplicationRecord
  belongs_to :user

  validates :cents, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :domain_name, presence: true
  validates :domain_name, uniqueness: { scope: :user_id }
  validate :validate_domain_name_for_exists

  def assign_initialize_params_for_mobile_api(strong_params)
    self.price = strong_params[:price]
    self.enable = true
  end

  def price
    Money.new(cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def price=(value)
    price = Money.from_amount(value.to_d, Setting.find_by(code: 'auction_currency').retrieve)
    self.cents = price.cents.positive? ? price.cents : nil
  end

  def validate_domain_name_for_exists
    domain = Auction.where(domain_name: domain_name).order(:created_at).last
    return if domain.present?

    errors.add(:domain_name, I18n.t('autobider.domain_name.does_not_exist'))
  end
end
