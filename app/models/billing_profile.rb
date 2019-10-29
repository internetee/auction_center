require 'countries'

class BillingProfile < ApplicationRecord
  include BillingHelpers
  alias_attribute :country_code, :alpha_two_country_code

  validates :name, presence: true
  validates :country_code, presence: true
  validates :vat_code, uniqueness: { scope: :user_id }, allow_blank: true

  belongs_to :user, optional: true
  before_destroy :check_no_active_offers_associated

  def user_name
    if user
      user.display_name
    else
      I18n.t('billing_profiles.orphaned')
    end
  end

  def self.create_default_for_user(user_id)
    return if find_by(user_id: user_id)

    user = User.find(user_id)

    billing_profile = new(user: user, country_code: user.country_code, name: user.display_name)
    billing_profile.save!

    billing_profile
  end

  def check_no_active_offers_associated
    return unless active_offers?

    errors.add(:base, I18n.t('billing_profiles.in_use_by_offer'))
    throw :abort
  end

  def active_offers?
    return false unless Offer.where(billing_profile_id: id).any?

    Offer.where(billing_profile_id: id).find_each do |offer|
      return true if offer.auction.result&.invoice.blank?
    end
    false
  end

  def nillify_user
    self.user_id = nil
    save
  end
end
