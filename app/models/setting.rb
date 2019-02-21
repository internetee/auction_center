class Setting < ApplicationRecord
  validates :code, presence: true
  validates :description, presence: true
  validates :value, presence: true
  validates :code, uniqueness: true

  def self.auction_currency
    Setting.find_by(code: :auction_currency).value
  end

  def self.auction_minimum_offer
    Setting.find_by(code: :auction_minimum_offer).value.to_i
  end

  def self.terms_and_conditions_link
    Setting.find_by(code: :terms_and_conditions_link).value
  end

  def self.default_country
    Setting.find_by(code: :default_country).value
  end

  def self.payment_term
    Setting.find_by(code: :payment_term).value.to_i
  end

  def self.registration_term
    Setting.find_by(code: :registration_term).value.to_i
  end

  def self.auction_duration
    Setting.find_by(code: :auction_duration).value.to_i
  end

  def self.require_phone_confirmation
    value = Setting.find_by(code: :require_phone_confirmation).value

    if value == 'true'
      true
    elsif value == 'false'
      false
    end
  end

  def self.auctions_start_at
    value = Setting.find_by(code: :auctions_start_at).value

    if value == 'false'
      false
    else
      value.to_i
    end
  end

  def self.ban_length
    Setting.find_by(code: :ban_length).value.to_i
  end
end
