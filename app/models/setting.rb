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
end
