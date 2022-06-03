class Offer < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user, optional: true
  belongs_to :auction, optional: false
  belongs_to :billing_profile, optional: false

  has_one :result, required: false, dependent: :nullify

  validates :cents, numericality: { only_integer: true, greater_than: 0 }
  validate :auction_must_be_active
  validate :must_be_higher_than_minimum_offer, if: proc { |offer| offer&.auction&.platform == 'blind' || offer&.auction&.platform.nil? }

  DEFAULT_PRICE_VALUE = 1

  after_create_commit ->{
    broadcast_update_to 'auctions',
                          # target: 'bids',
                          target: "#{dom_id(self.auction)}",
                          partial: 'auctions/auction',
                          locals: { auction: Auction.with_user_offers(user.id).find_by(uuid: auction.uuid), current_user: self.user } }

  after_update_commit ->{
    broadcast_update_to 'auctions',
                          target: "#{dom_id(self.auction)}",
                          partial: 'auctions/auction',
                          locals: { auction: Auction.with_user_offers(user.id).find_by(uuid: auction.uuid), current_user: self.user } }

  attr_accessor :skip_autobider

  def auction_must_be_active
    active_auction = Auction.active.find_by(id: auction_id)
    return if active_auction

    errors.add(:auction, I18n.t('offers.must_be_active'))
  end

  def must_be_higher_than_minimum_offer
    minimum_offer = Setting.find_by(code: 'auction_minimum_offer').retrieve
    return if minimum_offer <= cents.to_i

    currency = Setting.find_by(code: 'auction_currency').retrieve
    minimum_offer_as_money = Money.new(minimum_offer, currency)

    errors.add(:price, I18n.t('offers.must_be_higher_than', minimum: minimum_offer_as_money))
  end

  def can_be_modified?
    auction.in_progress?
  end

  def price
    Money.new(cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def price=(value)
    number = value.to_d
    price = Money.from_amount(number, Setting.find_by(code: 'auction_currency').retrieve)
    self.cents = price.cents
  end

  def total
    return price * (DEFAULT_PRICE_VALUE + billing_profile.vat_rate) if billing_profile.present?

    default_vat = Countries.vat_rate_from_alpha2_code(user&.country_code || 'EE')
    price * (DEFAULT_PRICE_VALUE + (Invoice.find_by(result: result)&.vat_rate || default_vat))
  end
end
